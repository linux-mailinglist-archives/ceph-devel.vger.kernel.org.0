Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB2DA5C7FA
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 05:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbfGBDyz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 23:54:55 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22511 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBDyz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 23:54:55 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAHY72J1RpdItX5AA--.188S2;
        Tue, 02 Jul 2019 11:54:49 +0800 (CST)
Subject: Re: [PATCH 19/20] rbd: support for object-map and fast-diff
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-20-idryomov@gmail.com> <5D199B3A.8070501@easystack.cn>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1AD589.40906@easystack.cn>
Date:   Tue, 2 Jul 2019 11:54:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <5D199B3A.8070501@easystack.cn>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAHY72J1RpdItX5AA--.188S2
X-Coremail-Antispam: 1Uf129KBjvAXoWfCw47uF45Cr4xWw4kCry8Xwb_yoW5Jr18Jo
        Wftr1xJa13Jr1DCrWkX3s2qFy5J3y8Ga43AFZ5WwsxCr4xKa42gw13Ca13Xay3ZF1S9r18
        C3WxX3WFyFW8Aw15n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRJ_-mUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZgrlellZumDAoAAAsJ
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 07/01/2019 01:33 PM, Dongsheng Yang wrote:
>
>
> On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
>> Speed up reads, discards and zeroouts through RBD_OBJ_FLAG_MAY_EXIST
>> and RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT based on object map.
>>
>> Invalid object maps are not trusted, but still updated.  Note that we
>> never iterate, resize or invalidate object maps.  If object-map feature
>> is enabled but object map fails to load, we just fail the requester
>> (either "rbd map" or I/O, by way of post-acquire action).
... ...
>> +
>> +    ret = rbd_object_map_lock(rbd_dev);
>
> hold the object_map lock in the whole rbd_device lifecycle? So if a 
> rbd is mapped, we can't do object-map operation (such as check, rebuild)?

Sorry, this would be unlocked in releasing exclusive-lock.

Thanx
Yang
>
> Thanx
> Yang
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = rbd_object_map_load(rbd_dev);
>> +    if (ret) {
>> +        rbd_object_map_unlock(rbd_dev);
>> +        return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +static void rbd_object_map_close(struct rbd_device *rbd_dev)
>> +{
>> +    rbd_object_map_free(rbd_dev);
>> +    rbd_object_map_unlock(rbd_dev);
>> +}
>> +
>> +/*
>> + * This function needs snap_id (or more precisely just something to
>> + * distinguish between HEAD and snapshot object maps), new_state and
>> + * current_state that were passed to rbd_object_map_update().
>> + *
>> + * To avoid allocating and stashing a context we piggyback on the OSD
>> + * request.  A HEAD update has two ops (assert_locked).  For new_state
>> + * and current_state we decode our own object_map_update op, encoded in
>> + * rbd_cls_object_map_update().
>> + */
>> +static int rbd_object_map_update_finish(struct rbd_obj_request 
>> *obj_req,
>> +                    struct ceph_osd_request *osd_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +    struct ceph_osd_data *osd_data;
>> +    u64 objno;
>> +    u8 state, new_state, current_state;
>> +    bool has_current_state;
>> +    void *p;
>> +
>> +    if (osd_req->r_result)
>> +        return osd_req->r_result;
>> +
>> +    /*
>> +     * Nothing to do for a snapshot object map.
>> +     */
>> +    if (osd_req->r_num_ops == 1)
>> +        return 0;
>> +
>> +    /*
>> +     * Update in-memory HEAD object map.
>> +     */
>> +    rbd_assert(osd_req->r_num_ops == 2);
>> +    osd_data = osd_req_op_data(osd_req, 1, cls, request_data);
>> +    rbd_assert(osd_data->type == CEPH_OSD_DATA_TYPE_PAGES);
>> +
>> +    p = page_address(osd_data->pages[0]);
>> +    objno = ceph_decode_64(&p);
>> +    rbd_assert(objno == obj_req->ex.oe_objno);
>> +    rbd_assert(ceph_decode_64(&p) == objno + 1);
>> +    new_state = ceph_decode_8(&p);
>> +    has_current_state = ceph_decode_8(&p);
>> +    if (has_current_state)
>> +        current_state = ceph_decode_8(&p);
>> +
>> +    spin_lock(&rbd_dev->object_map_lock);
>> +    state = __rbd_object_map_get(rbd_dev, objno);
>> +    if (!has_current_state || current_state == state ||
>> +        (current_state == OBJECT_EXISTS && state == 
>> OBJECT_EXISTS_CLEAN))
>> +        __rbd_object_map_set(rbd_dev, objno, new_state);
>> +    spin_unlock(&rbd_dev->object_map_lock);
>> +
>> +    return 0;
>> +}
>> +
>> +static void rbd_object_map_callback(struct ceph_osd_request *osd_req)
>> +{
>> +    struct rbd_obj_request *obj_req = osd_req->r_priv;
>> +    int result;
>> +
>> +    dout("%s osd_req %p result %d for obj_req %p\n", __func__, osd_req,
>> +         osd_req->r_result, obj_req);
>> +
>> +    result = rbd_object_map_update_finish(obj_req, osd_req);
>> +    rbd_obj_handle_request(obj_req, result);
>> +}
>> +
>> +static bool update_needed(struct rbd_device *rbd_dev, u64 objno, u8 
>> new_state)
>> +{
>> +    u8 state = rbd_object_map_get(rbd_dev, objno);
>> +
>> +    if (state == new_state ||
>> +        (new_state == OBJECT_PENDING && state == OBJECT_NONEXISTENT) ||
>> +        (new_state == OBJECT_NONEXISTENT && state != OBJECT_PENDING))
>> +        return false;
>> +
>> +    return true;
>> +}
>> +
>> +static int rbd_cls_object_map_update(struct ceph_osd_request *req,
>> +                     int which, u64 objno, u8 new_state,
>> +                     const u8 *current_state)
>> +{
>> +    struct page **pages;
>> +    void *p, *start;
>> +    int ret;
>> +
>> +    ret = osd_req_op_cls_init(req, which, "rbd", "object_map_update");
>> +    if (ret)
>> +        return ret;
>> +
>> +    pages = ceph_alloc_page_vector(1, GFP_NOIO);
>> +    if (IS_ERR(pages))
>> +        return PTR_ERR(pages);
>> +
>> +    p = start = page_address(pages[0]);
>> +    ceph_encode_64(&p, objno);
>> +    ceph_encode_64(&p, objno + 1);
>> +    ceph_encode_8(&p, new_state);
>> +    if (current_state) {
>> +        ceph_encode_8(&p, 1);
>> +        ceph_encode_8(&p, *current_state);
>> +    } else {
>> +        ceph_encode_8(&p, 0);
>> +    }
>> +
>> +    osd_req_op_cls_request_data_pages(req, which, pages, p - start, 0,
>> +                      false, true);
>> +    return 0;
>> +}
>> +
>> +/*
>> + * Return:
>> + *   0 - object map update sent
>> + *   1 - object map update isn't needed
>> + *  <0 - error
>> + */
>> +static int rbd_object_map_update(struct rbd_obj_request *obj_req, 
>> u64 snap_id,
>> +                 u8 new_state, const u8 *current_state)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +    struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
>> +    struct ceph_osd_request *req;
>> +    int num_ops = 1;
>> +    int which = 0;
>> +    int ret;
>> +
>> +    if (snap_id == CEPH_NOSNAP) {
>> +        if (!update_needed(rbd_dev, obj_req->ex.oe_objno, new_state))
>> +            return 1;
>> +
>> +        num_ops++; /* assert_locked */
>> +    }
>> +
>> +    req = ceph_osdc_alloc_request(osdc, NULL, num_ops, false, 
>> GFP_NOIO);
>> +    if (!req)
>> +        return -ENOMEM;
>> +
>> +    list_add_tail(&req->r_unsafe_item, &obj_req->osd_reqs);
>> +    req->r_callback = rbd_object_map_callback;
>> +    req->r_priv = obj_req;
>> +
>> +    rbd_object_map_name(rbd_dev, snap_id, &req->r_base_oid);
>> +    ceph_oloc_copy(&req->r_base_oloc, &rbd_dev->header_oloc);
>> +    req->r_flags = CEPH_OSD_FLAG_WRITE;
>> +    ktime_get_real_ts64(&req->r_mtime);
>> +
>> +    if (snap_id == CEPH_NOSNAP) {
>> +        /*
>> +         * Protect against possible race conditions during lock
>> +         * ownership transitions.
>> +         */
>> +        ret = ceph_cls_assert_locked(req, which++, RBD_LOCK_NAME,
>> +                         CEPH_CLS_LOCK_EXCLUSIVE, "", "");
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    ret = rbd_cls_object_map_update(req, which, obj_req->ex.oe_objno,
>> +                    new_state, current_state);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
>> +    if (ret)
>> +        return ret;
>> +
>> +    ceph_osdc_start_request(osdc, req, false);
>> +    return 0;
>> +}
>> +
>>   static void prune_extents(struct ceph_file_extent *img_extents,
>>                 u32 *num_img_extents, u64 overlap)
>>   {
>> @@ -1975,6 +2452,7 @@ static int rbd_obj_init_discard(struct 
>> rbd_obj_request *obj_req)
>>       if (ret)
>>           return ret;
>>   +    obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
>>       if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents)
>>           obj_req->flags |= RBD_OBJ_FLAG_DELETION;
>>   @@ -2022,6 +2500,7 @@ static int rbd_obj_init_zeroout(struct 
>> rbd_obj_request *obj_req)
>>       if (rbd_obj_copyup_enabled(obj_req))
>>           obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
>>       if (!obj_req->num_img_extents) {
>> +        obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
>>           if (rbd_obj_is_entire(obj_req))
>>               obj_req->flags |= RBD_OBJ_FLAG_DELETION;
>>       }
>> @@ -2407,6 +2886,20 @@ static void rbd_img_schedule(struct 
>> rbd_img_request *img_req, int result)
>>       queue_work(rbd_wq, &img_req->work);
>>   }
>>   +static bool rbd_obj_may_exist(struct rbd_obj_request *obj_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +
>> +    if (rbd_object_map_may_exist(rbd_dev, obj_req->ex.oe_objno)) {
>> +        obj_req->flags |= RBD_OBJ_FLAG_MAY_EXIST;
>> +        return true;
>> +    }
>> +
>> +    dout("%s %p objno %llu assuming dne\n", __func__, obj_req,
>> +         obj_req->ex.oe_objno);
>> +    return false;
>> +}
>> +
>>   static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
>>   {
>>       struct ceph_osd_request *osd_req;
>> @@ -2482,10 +2975,17 @@ static bool rbd_obj_advance_read(struct 
>> rbd_obj_request *obj_req, int *result)
>>       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>>       int ret;
>>   +again:
>>       switch (obj_req->read_state) {
>>       case RBD_OBJ_READ_START:
>>           rbd_assert(!*result);
>>   +        if (!rbd_obj_may_exist(obj_req)) {
>> +            *result = -ENOENT;
>> +            obj_req->read_state = RBD_OBJ_READ_OBJECT;
>> +            goto again;
>> +        }
>> +
>>           ret = rbd_obj_read_object(obj_req);
>>           if (ret) {
>>               *result = ret;
>> @@ -2536,6 +3036,44 @@ static bool rbd_obj_advance_read(struct 
>> rbd_obj_request *obj_req, int *result)
>>       }
>>   }
>>   +static bool rbd_obj_write_is_noop(struct rbd_obj_request *obj_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +
>> +    if (rbd_object_map_may_exist(rbd_dev, obj_req->ex.oe_objno))
>> +        obj_req->flags |= RBD_OBJ_FLAG_MAY_EXIST;
>> +
>> +    if (!(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST) &&
>> +        (obj_req->flags & RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT)) {
>> +        dout("%s %p noop for nonexistent\n", __func__, obj_req);
>> +        return true;
>> +    }
>> +
>> +    return false;
>> +}
>> +
>> +/*
>> + * Return:
>> + *   0 - object map update sent
>> + *   1 - object map update isn't needed
>> + *  <0 - error
>> + */
>> +static int rbd_obj_write_pre_object_map(struct rbd_obj_request 
>> *obj_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +    u8 new_state;
>> +
>> +    if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>> +        return 1;
>> +
>> +    if (obj_req->flags & RBD_OBJ_FLAG_DELETION)
>> +        new_state = OBJECT_PENDING;
>> +    else
>> +        new_state = OBJECT_EXISTS;
>> +
>> +    return rbd_object_map_update(obj_req, CEPH_NOSNAP, new_state, 
>> NULL);
>> +}
>> +
>>   static int rbd_obj_write_object(struct rbd_obj_request *obj_req)
>>   {
>>       struct ceph_osd_request *osd_req;
>> @@ -2706,6 +3244,41 @@ static int rbd_obj_copyup_read_parent(struct 
>> rbd_obj_request *obj_req)
>>       return rbd_obj_read_from_parent(obj_req);
>>   }
>>   +static void rbd_obj_copyup_object_maps(struct rbd_obj_request 
>> *obj_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +    struct ceph_snap_context *snapc = obj_req->img_request->snapc;
>> +    u8 new_state;
>> +    u32 i;
>> +    int ret;
>> +
>> +    rbd_assert(!obj_req->pending.result && 
>> !obj_req->pending.num_pending);
>> +
>> +    if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>> +        return;
>> +
>> +    if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ZEROS)
>> +        return;
>> +
>> +    for (i = 0; i < snapc->num_snaps; i++) {
>> +        if ((rbd_dev->header.features & RBD_FEATURE_FAST_DIFF) &&
>> +            i + 1 < snapc->num_snaps)
>> +            new_state = OBJECT_EXISTS_CLEAN;
>> +        else
>> +            new_state = OBJECT_EXISTS;
>> +
>> +        ret = rbd_object_map_update(obj_req, snapc->snaps[i],
>> +                        new_state, NULL);
>> +        if (ret < 0) {
>> +            obj_req->pending.result = ret;
>> +            return;
>> +        }
>> +
>> +        rbd_assert(!ret);
>> +        obj_req->pending.num_pending++;
>> +    }
>> +}
>> +
>>   static void rbd_obj_copyup_write_object(struct rbd_obj_request 
>> *obj_req)
>>   {
>>       u32 bytes = rbd_obj_img_extents_bytes(obj_req);
>> @@ -2749,6 +3322,7 @@ static void rbd_obj_copyup_write_object(struct 
>> rbd_obj_request *obj_req)
>>     static bool rbd_obj_advance_copyup(struct rbd_obj_request 
>> *obj_req, int *result)
>>   {
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>>       int ret;
>>     again:
>> @@ -2776,6 +3350,25 @@ static bool rbd_obj_advance_copyup(struct 
>> rbd_obj_request *obj_req, int *result)
>>               obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ZEROS;
>>           }
>>   +        rbd_obj_copyup_object_maps(obj_req);
>> +        if (!obj_req->pending.num_pending) {
>> +            *result = obj_req->pending.result;
>> +            obj_req->copyup_state = RBD_OBJ_COPYUP_OBJECT_MAPS;
>> +            goto again;
>> +        }
>> +        obj_req->copyup_state = __RBD_OBJ_COPYUP_OBJECT_MAPS;
>> +        return false;
>> +    case __RBD_OBJ_COPYUP_OBJECT_MAPS:
>> +        if (!pending_result_dec(&obj_req->pending, result))
>> +            return false;
>> +        /* fall through */
>> +    case RBD_OBJ_COPYUP_OBJECT_MAPS:
>> +        if (*result) {
>> +            rbd_warn(rbd_dev, "snap object map update failed: %d",
>> +                 *result);
>> +            return true;
>> +        }
>> +
>>           rbd_obj_copyup_write_object(obj_req);
>>           if (!obj_req->pending.num_pending) {
>>               *result = obj_req->pending.result;
>> @@ -2795,6 +3388,27 @@ static bool rbd_obj_advance_copyup(struct 
>> rbd_obj_request *obj_req, int *result)
>>       }
>>   }
>>   +/*
>> + * Return:
>> + *   0 - object map update sent
>> + *   1 - object map update isn't needed
>> + *  <0 - error
>> + */
>> +static int rbd_obj_write_post_object_map(struct rbd_obj_request 
>> *obj_req)
>> +{
>> +    struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> +    u8 current_state = OBJECT_PENDING;
>> +
>> +    if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>> +        return 1;
>> +
>> +    if (!(obj_req->flags & RBD_OBJ_FLAG_DELETION))
>> +        return 1;
>> +
>> +    return rbd_object_map_update(obj_req, CEPH_NOSNAP, 
>> OBJECT_NONEXISTENT,
>> +                     &current_state);
>> +}
>> +
>>   static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, 
>> int *result)
>>   {
>>       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>> @@ -2805,6 +3419,24 @@ static bool rbd_obj_advance_write(struct 
>> rbd_obj_request *obj_req, int *result)
>>       case RBD_OBJ_WRITE_START:
>>           rbd_assert(!*result);
>>   +        if (rbd_obj_write_is_noop(obj_req))
>> +            return true;
>> +
>> +        ret = rbd_obj_write_pre_object_map(obj_req);
>> +        if (ret < 0) {
>> +            *result = ret;
>> +            return true;
>> +        }
>> +        obj_req->write_state = RBD_OBJ_WRITE_PRE_OBJECT_MAP;
>> +        if (ret > 0)
>> +            goto again;
>> +        return false;
>> +    case RBD_OBJ_WRITE_PRE_OBJECT_MAP:
>> +        if (*result) {
>> +            rbd_warn(rbd_dev, "pre object map update failed: %d",
>> +                 *result);
>> +            return true;
>> +        }
>>           ret = rbd_obj_write_object(obj_req);
>>           if (ret) {
>>               *result = ret;
>> @@ -2837,8 +3469,23 @@ static bool rbd_obj_advance_write(struct 
>> rbd_obj_request *obj_req, int *result)
>>               return false;
>>           /* fall through */
>>       case RBD_OBJ_WRITE_COPYUP:
>> -        if (*result)
>> +        if (*result) {
>>               rbd_warn(rbd_dev, "copyup failed: %d", *result);
>> +            return true;
>> +        }
>> +        ret = rbd_obj_write_post_object_map(obj_req);
>> +        if (ret < 0) {
>> +            *result = ret;
>> +            return true;
>> +        }
>> +        obj_req->write_state = RBD_OBJ_WRITE_POST_OBJECT_MAP;
>> +        if (ret > 0)
>> +            goto again;
>> +        return false;
>> +    case RBD_OBJ_WRITE_POST_OBJECT_MAP:
>> +        if (*result)
>> +            rbd_warn(rbd_dev, "post object map update failed: %d",
>> +                 *result);
>>           return true;
>>       default:
>>           BUG();
>> @@ -2892,7 +3539,8 @@ static bool need_exclusive_lock(struct 
>> rbd_img_request *img_req)
>>           return false;
>>         rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
>> -    if (rbd_dev->opts->lock_on_read)
>> +    if (rbd_dev->opts->lock_on_read ||
>> +        (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
>>           return true;
>>         return rbd_img_is_write(img_req);
>> @@ -3427,7 +4075,7 @@ static int rbd_try_lock(struct rbd_device 
>> *rbd_dev)
>>           if (ret)
>>               goto out; /* request lock or error */
>>   -        rbd_warn(rbd_dev, "%s%llu seems dead, breaking lock",
>> +        rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
>>                ENTITY_NAME(lockers[0].id.name));
>>             ret = ceph_monc_blacklist_add(&client->monc,
>> @@ -3454,6 +4102,19 @@ static int rbd_try_lock(struct rbd_device 
>> *rbd_dev)
>>       return ret;
>>   }
>>   +static int rbd_post_acquire_action(struct rbd_device *rbd_dev)
>> +{
>> +    int ret;
>> +
>> +    if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
>> +        ret = rbd_object_map_open(rbd_dev);
>> +        if (ret)
>> +            return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   /*
>>    * Return:
>>    *   0 - lock acquired
>> @@ -3497,6 +4158,17 @@ static int rbd_try_acquire_lock(struct 
>> rbd_device *rbd_dev)
>>       rbd_assert(rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED);
>>       rbd_assert(list_empty(&rbd_dev->running_list));
>>   +    ret = rbd_post_acquire_action(rbd_dev);
>> +    if (ret) {
>> +        rbd_warn(rbd_dev, "post-acquire action failed: %d", ret);
>> +        /*
>> +         * Can't stay in RBD_LOCK_STATE_LOCKED because
>> +         * rbd_lock_add_request() would let the request through,
>> +         * assuming that e.g. object map is locked and loaded.
>> +         */
>> +        rbd_unlock(rbd_dev);
>> +    }
>> +
>>   out:
>>       wake_requests(rbd_dev, ret);
>>       up_write(&rbd_dev->lock_rwsem);
>> @@ -3570,10 +4242,17 @@ static bool rbd_quiesce_lock(struct 
>> rbd_device *rbd_dev)
>>       return true;
>>   }
>>   +static void rbd_pre_release_action(struct rbd_device *rbd_dev)
>> +{
>> +    if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)
>> +        rbd_object_map_close(rbd_dev);
>> +}
>> +
>>   static void __rbd_release_lock(struct rbd_device *rbd_dev)
>>   {
>>       rbd_assert(list_empty(&rbd_dev->running_list));
>>   +    rbd_pre_release_action(rbd_dev);
>>       rbd_unlock(rbd_dev);
>>   }
>>   @@ -4860,6 +5539,8 @@ static struct rbd_device 
>> *__rbd_dev_create(struct rbd_client *rbdc,
>>       init_completion(&rbd_dev->acquire_wait);
>>       init_completion(&rbd_dev->releasing_wait);
>>   +    spin_lock_init(&rbd_dev->object_map_lock);
>> +
>>       rbd_dev->dev.bus = &rbd_bus_type;
>>       rbd_dev->dev.type = &rbd_device_type;
>>       rbd_dev->dev.parent = &rbd_root_dev;
>> @@ -5041,6 +5722,32 @@ static int rbd_dev_v2_features(struct 
>> rbd_device *rbd_dev)
>>                           &rbd_dev->header.features);
>>   }
>>   +/*
>> + * These are generic image flags, but since they are used only for
>> + * object map, store them in rbd_dev->object_map_flags.
>> + *
>> + * For the same reason, this function is called only on object map
>> + * (re)load and not on header refresh.
>> + */
>> +static int rbd_dev_v2_get_flags(struct rbd_device *rbd_dev)
>> +{
>> +    __le64 snapid = cpu_to_le64(rbd_dev->spec->snap_id);
>> +    __le64 flags;
>> +    int ret;
>> +
>> +    ret = rbd_obj_method_sync(rbd_dev, &rbd_dev->header_oid,
>> +                  &rbd_dev->header_oloc, "get_flags",
>> +                  &snapid, sizeof(snapid),
>> +                  &flags, sizeof(flags));
>> +    if (ret < 0)
>> +        return ret;
>> +    if (ret < sizeof(flags))
>> +        return -EBADMSG;
>> +
>> +    rbd_dev->object_map_flags = le64_to_cpu(flags);
>> +    return 0;
>> +}
>> +
>>   struct parent_image_info {
>>       u64        pool_id;
>>       const char    *pool_ns;
>> @@ -6014,6 +6721,7 @@ static void rbd_dev_unprobe(struct rbd_device 
>> *rbd_dev)
>>       struct rbd_image_header    *header;
>>         rbd_dev_parent_put(rbd_dev);
>> +    rbd_object_map_free(rbd_dev);
>>       rbd_dev_mapping_clear(rbd_dev);
>>         /* Free dynamic fields from the header, then zero it out */
>> @@ -6263,6 +6971,13 @@ static int rbd_dev_image_probe(struct 
>> rbd_device *rbd_dev, int depth)
>>       if (ret)
>>           goto err_out_probe;
>>   +    if (rbd_dev->spec->snap_id != CEPH_NOSNAP &&
>> +        (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)) {
>> +        ret = rbd_object_map_load(rbd_dev);
>> +        if (ret)
>> +            goto err_out_probe;
>> +    }
>> +
>>       if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
>>           ret = rbd_dev_v2_parent_info(rbd_dev);
>>           if (ret)
>> diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
>> index 62ff50d3e7a6..ac98ab6ccd3b 100644
>> --- a/drivers/block/rbd_types.h
>> +++ b/drivers/block/rbd_types.h
>> @@ -18,6 +18,7 @@
>>   /* For format version 2, rbd image 'foo' consists of objects
>>    *   rbd_id.foo        - id of image
>>    *   rbd_header.<id>    - image metadata
>> + *   rbd_object_map.<id> - optional image object map
>>    *   rbd_data.<id>.0000000000000000
>>    *   rbd_data.<id>.0000000000000001
>>    *   ...        - data
>> @@ -25,6 +26,7 @@
>>    */
>>     #define RBD_HEADER_PREFIX      "rbd_header."
>> +#define RBD_OBJECT_MAP_PREFIX  "rbd_object_map."
>>   #define RBD_ID_PREFIX          "rbd_id."
>>   #define RBD_V2_DATA_FORMAT     "%s.%016llx"
>>   @@ -39,6 +41,14 @@ enum rbd_notify_op {
>>       RBD_NOTIFY_OP_HEADER_UPDATE      = 3,
>>   };
>>   +#define OBJECT_NONEXISTENT    0
>> +#define OBJECT_EXISTS        1
>> +#define OBJECT_PENDING        2
>> +#define OBJECT_EXISTS_CLEAN    3
>> +
>> +#define RBD_FLAG_OBJECT_MAP_INVALID    (1ULL << 0)
>> +#define RBD_FLAG_FAST_DIFF_INVALID    (1ULL << 1)
>> +
>>   /*
>>    * For format version 1, rbd image 'foo' consists of objects
>>    *   foo.rbd        - image metadata
>> diff --git a/include/linux/ceph/cls_lock_client.h 
>> b/include/linux/ceph/cls_lock_client.h
>> index bea6c77d2093..17bc7584d1fe 100644
>> --- a/include/linux/ceph/cls_lock_client.h
>> +++ b/include/linux/ceph/cls_lock_client.h
>> @@ -52,4 +52,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
>>                  char *lock_name, u8 *type, char **tag,
>>                  struct ceph_locker **lockers, u32 *num_lockers);
>>   +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
>> +               char *lock_name, u8 type, char *cookie, char *tag);
>> +
>>   #endif
>> diff --git a/include/linux/ceph/striper.h b/include/linux/ceph/striper.h
>> index cbd0d24b7148..3486636c0e6e 100644
>> --- a/include/linux/ceph/striper.h
>> +++ b/include/linux/ceph/striper.h
>> @@ -66,4 +66,6 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
>>               struct ceph_file_extent **file_extents,
>>               u32 *num_file_extents);
>>   +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size);
>> +
>>   #endif
>> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
>> index 56bbfe01e3ac..99cce6f3ec48 100644
>> --- a/net/ceph/cls_lock_client.c
>> +++ b/net/ceph/cls_lock_client.c
>> @@ -6,6 +6,7 @@
>>     #include <linux/ceph/cls_lock_client.h>
>>   #include <linux/ceph/decode.h>
>> +#include <linux/ceph/libceph.h>
>>     /**
>>    * ceph_cls_lock - grab rados lock for object
>> @@ -375,3 +376,47 @@ int ceph_cls_lock_info(struct ceph_osd_client 
>> *osdc,
>>       return ret;
>>   }
>>   EXPORT_SYMBOL(ceph_cls_lock_info);
>> +
>> +int ceph_cls_assert_locked(struct ceph_osd_request *req, int which,
>> +               char *lock_name, u8 type, char *cookie, char *tag)
>> +{
>> +    int assert_op_buf_size;
>> +    int name_len = strlen(lock_name);
>> +    int cookie_len = strlen(cookie);
>> +    int tag_len = strlen(tag);
>> +    struct page **pages;
>> +    void *p, *end;
>> +    int ret;
>> +
>> +    assert_op_buf_size = name_len + sizeof(__le32) +
>> +                 cookie_len + sizeof(__le32) +
>> +                 tag_len + sizeof(__le32) +
>> +                 sizeof(u8) + CEPH_ENCODING_START_BLK_LEN;
>> +    if (assert_op_buf_size > PAGE_SIZE)
>> +        return -E2BIG;
>> +
>> +    ret = osd_req_op_cls_init(req, which, "lock", "assert_locked");
>> +    if (ret)
>> +        return ret;
>> +
>> +    pages = ceph_alloc_page_vector(1, GFP_NOIO);
>> +    if (IS_ERR(pages))
>> +        return PTR_ERR(pages);
>> +
>> +    p = page_address(pages[0]);
>> +    end = p + assert_op_buf_size;
>> +
>> +    /* encode cls_lock_assert_op struct */
>> +    ceph_start_encoding(&p, 1, 1,
>> +                assert_op_buf_size - CEPH_ENCODING_START_BLK_LEN);
>> +    ceph_encode_string(&p, end, lock_name, name_len);
>> +    ceph_encode_8(&p, type);
>> +    ceph_encode_string(&p, end, cookie, cookie_len);
>> +    ceph_encode_string(&p, end, tag, tag_len);
>> +    WARN_ON(p != end);
>> +
>> +    osd_req_op_cls_request_data_pages(req, which, pages, 
>> assert_op_buf_size,
>> +                      0, false, true);
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL(ceph_cls_assert_locked);
>> diff --git a/net/ceph/striper.c b/net/ceph/striper.c
>> index c36462dc86b7..3b3fa75d1189 100644
>> --- a/net/ceph/striper.c
>> +++ b/net/ceph/striper.c
>> @@ -259,3 +259,20 @@ int ceph_extent_to_file(struct ceph_file_layout *l,
>>       return 0;
>>   }
>>   EXPORT_SYMBOL(ceph_extent_to_file);
>> +
>> +u64 ceph_get_num_objects(struct ceph_file_layout *l, u64 size)
>> +{
>> +    u64 period = (u64)l->stripe_count * l->object_size;
>> +    u64 num_periods = DIV64_U64_ROUND_UP(size, period);
>> +    u64 remainder_bytes;
>> +    u64 remainder_objs = 0;
>> +
>> +    div64_u64_rem(size, period, &remainder_bytes);
>> +    if (remainder_bytes > 0 &&
>> +        remainder_bytes < (u64)l->stripe_count * l->stripe_unit)
>> +        remainder_objs = l->stripe_count -
>> +                DIV_ROUND_UP_ULL(remainder_bytes, l->stripe_unit);
>> +
>> +    return num_periods * l->stripe_count - remainder_objs;
>> +}
>> +EXPORT_SYMBOL(ceph_get_num_objects);
>
>
>


