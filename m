Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109A026BDE6
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Sep 2020 09:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIPH0E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Sep 2020 03:26:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbgIPH0B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 03:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600241158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pYN/FG5BeYw7FdkVBfbR0U5jLX1NaSGXMPKZGaQBfS0=;
        b=DnqJTv7DnstjgI6YzovwucyjnOl28R1cF5VXz9CU7Hz7wwsMJwSnkqXvEqIDSXUSsP7IDa
        0avUGfxmve9qkLThTCYarN5YFQ855mljlwdi79vDJjVvX2CTVA8RvMCBlpYQayI8CQdm4E
        jFFp91QL6488lwed5FVUgMlfnp6Gfq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-hY5YPofGOYKQWKbP1zK8iw-1; Wed, 16 Sep 2020 03:25:53 -0400
X-MC-Unique: hY5YPofGOYKQWKbP1zK8iw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 389F3801AF2;
        Wed, 16 Sep 2020 07:25:52 +0000 (UTC)
Received: from [10.72.12.62] (ovpn-12-62.pek2.redhat.com [10.72.12.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD85E5DE86;
        Wed, 16 Sep 2020 07:25:50 +0000 (UTC)
Subject: Re: [PATCH 1/3] libceph, rbd, ceph: "blacklist" -> "blocklist"
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
References: <20200915203323.4688-1-idryomov@gmail.com>
 <20200915203323.4688-2-idryomov@gmail.com>
 <4bef218f-03b8-b1cf-57ef-e2d1ddf79d45@redhat.com>
 <CAOi1vP-ygPk_CTGQYisR3b3oybP=d4DfM31cpx6jTqLNBHiMbg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <19dbdc47-f48c-d43f-1ca7-d3873984d38e@redhat.com>
Date:   Wed, 16 Sep 2020 15:25:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-ygPk_CTGQYisR3b3oybP=d4DfM31cpx6jTqLNBHiMbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/16 15:15, Ilya Dryomov wrote:
> On Wed, Sep 16, 2020 at 4:16 AM Xiubo Li <xiubli@redhat.com> wrote:
>> On 2020/9/16 4:33, Ilya Dryomov wrote:
>>> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
>>> ---
>>>    Documentation/filesystems/ceph.rst |  6 +++---
>>>    drivers/block/rbd.c                |  8 ++++----
>>>    fs/ceph/addr.c                     | 24 ++++++++++++------------
>>>    fs/ceph/file.c                     |  4 ++--
>>>    fs/ceph/mds_client.c               | 16 ++++++++--------
>>>    fs/ceph/super.c                    |  4 ++--
>>>    fs/ceph/super.h                    |  4 ++--
>>>    include/linux/ceph/mon_client.h    |  2 +-
>>>    include/linux/ceph/rados.h         |  2 +-
>>>    net/ceph/mon_client.c              |  8 ++++----
>>>    10 files changed, 39 insertions(+), 39 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
>>> index 0aa70750df0f..7d2ef4e27273 100644
>>> --- a/Documentation/filesystems/ceph.rst
>>> +++ b/Documentation/filesystems/ceph.rst
>>> @@ -163,14 +163,14 @@ Mount Options
>>>            to the default VFS implementation if this option is used.
>>>
>>>      recover_session=<no|clean>
>>> -     Set auto reconnect mode in the case where the client is blacklisted. The
>>> +     Set auto reconnect mode in the case where the client is blocklisted. The
>>>        available modes are "no" and "clean". The default is "no".
>>>
>>>        * no: never attempt to reconnect when client detects that it has been
>>> -       blacklisted. Operations will generally fail after being blacklisted.
>>> +       blocklisted. Operations will generally fail after being blocklisted.
>>>
>>>        * clean: client reconnects to the ceph cluster automatically when it
>>> -       detects that it has been blacklisted. During reconnect, client drops
>>> +       detects that it has been blocklisted. During reconnect, client drops
>>>          dirty data/metadata, invalidates page caches and writable file handles.
>>>          After reconnect, file locks become stale because the MDS loses track
>>>          of them. If an inode contains any stale file locks, read/write on the
>>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>>> index 180587ce606c..d21fecfe3eba 100644
>>> --- a/drivers/block/rbd.c
>>> +++ b/drivers/block/rbd.c
>>> @@ -4010,10 +4010,10 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
>>>                rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
>>>                         ENTITY_NAME(lockers[0].id.name));
>>>
>>> -             ret = ceph_monc_blacklist_add(&client->monc,
>>> +             ret = ceph_monc_blocklist_add(&client->monc,
>>>                                              &lockers[0].info.addr);
>>>                if (ret) {
>>> -                     rbd_warn(rbd_dev, "blacklist of %s%llu failed: %d",
>>> +                     rbd_warn(rbd_dev, "blocklist of %s%llu failed: %d",
>>>                                 ENTITY_NAME(lockers[0].id.name), ret);
>>>                        goto out;
>>>                }
>>> @@ -4077,7 +4077,7 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
>>>        ret = rbd_try_lock(rbd_dev);
>>>        if (ret < 0) {
>>>                rbd_warn(rbd_dev, "failed to lock header: %d", ret);
>>> -             if (ret == -EBLACKLISTED)
>>> +             if (ret == -EBLOCKLISTED)
>>>                        goto out;
>>>
>>>                ret = 1; /* request lock anyway */
>>> @@ -4613,7 +4613,7 @@ static void rbd_reregister_watch(struct work_struct *work)
>>>        ret = __rbd_register_watch(rbd_dev);
>>>        if (ret) {
>>>                rbd_warn(rbd_dev, "failed to reregister watch: %d", ret);
>>> -             if (ret != -EBLACKLISTED && ret != -ENOENT) {
>>> +             if (ret != -EBLOCKLISTED && ret != -ENOENT) {
>>>                        queue_delayed_work(rbd_dev->task_wq,
>>>                                           &rbd_dev->watch_dwork,
>>>                                           RBD_RETRY_DELAY);
>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> index b03dbaa9d345..7b1f3dad576f 100644
>>> --- a/fs/ceph/addr.c
>>> +++ b/fs/ceph/addr.c
>>> @@ -271,8 +271,8 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
>>>        if (err < 0) {
>>>                SetPageError(page);
>>>                ceph_fscache_readpage_cancel(inode, page);
>>> -             if (err == -EBLACKLISTED)
>>> -                     fsc->blacklisted = true;
>>> +             if (err == -EBLOCKLISTED)
>>> +                     fsc->blocklisted = true;
>>>                goto out;
>>>        }
>>>        if (err < PAGE_SIZE)
>>> @@ -312,8 +312,8 @@ static void finish_read(struct ceph_osd_request *req)
>>>        int i;
>>>
>>>        dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
>>> -     if (rc == -EBLACKLISTED)
>>> -             ceph_inode_to_client(inode)->blacklisted = true;
>>> +     if (rc == -EBLOCKLISTED)
>>> +             ceph_inode_to_client(inode)->blocklisted = true;
>>>
>>>        /* unlock all pages, zeroing any data we didn't read */
>>>        osd_data = osd_req_op_extent_osd_data(req, 0);
>>> @@ -737,8 +737,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>                        end_page_writeback(page);
>>>                        return err;
>>>                }
>>> -             if (err == -EBLACKLISTED)
>>> -                     fsc->blacklisted = true;
>>> +             if (err == -EBLOCKLISTED)
>>> +                     fsc->blocklisted = true;
>>>                dout("writepage setting page/mapping error %d %p\n",
>>>                     err, page);
>>>                mapping_set_error(&inode->i_data, err);
>>> @@ -801,8 +801,8 @@ static void writepages_finish(struct ceph_osd_request *req)
>>>        if (rc < 0) {
>>>                mapping_set_error(mapping, rc);
>>>                ceph_set_error_write(ci);
>>> -             if (rc == -EBLACKLISTED)
>>> -                     fsc->blacklisted = true;
>>> +             if (rc == -EBLOCKLISTED)
>>> +                     fsc->blocklisted = true;
>>>        } else {
>>>                ceph_clear_error_write(ci);
>>>        }
>>> @@ -2038,16 +2038,16 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
>>>        if (err >= 0 || err == -ENOENT)
>>>                have |= POOL_READ;
>>>        else if (err != -EPERM) {
>>> -             if (err == -EBLACKLISTED)
>>> -                     fsc->blacklisted = true;
>>> +             if (err == -EBLOCKLISTED)
>>> +                     fsc->blocklisted = true;
>>>                goto out_unlock;
>>>        }
>>>
>>>        if (err2 == 0 || err2 == -EEXIST)
>>>                have |= POOL_WRITE;
>>>        else if (err2 != -EPERM) {
>>> -             if (err2 == -EBLACKLISTED)
>>> -                     fsc->blacklisted = true;
>>> +             if (err2 == -EBLOCKLISTED)
>>> +                     fsc->blocklisted = true;
>>>                err = err2;
>>>                goto out_unlock;
>>>        }
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 762a280b7037..209535d5b8d3 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -933,8 +933,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>>>                ceph_release_page_vector(pages, num_pages);
>>>
>>>                if (ret < 0) {
>>> -                     if (ret == -EBLACKLISTED)
>>> -                             fsc->blacklisted = true;
>>> +                     if (ret == -EBLOCKLISTED)
>>> +                             fsc->blocklisted = true;
>>>                        break;
>>>                }
>>>
>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>> index 76d8d9495d1d..bb2d938a17ac 100644
>>> --- a/fs/ceph/mds_client.c
>>> +++ b/fs/ceph/mds_client.c
>>> @@ -3303,7 +3303,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
>>>    }
>>>
>>>    static int __decode_session_metadata(void **p, void *end,
>>> -                                  bool *blacklisted)
>>> +                                  bool *blocklisted)
>>>    {
>>>        /* map<string,string> */
>>>        u32 n;
>>> @@ -3318,7 +3318,7 @@ static int __decode_session_metadata(void **p, void *end,
>>>                ceph_decode_32_safe(p, end, len, bad);
>>>                ceph_decode_need(p, end, len, bad);
>>>                if (err_str && strnstr(*p, "blacklisted", len))
>> BTW, for new MDS shouldn't we check "blocklisted" first ? And then
>> "blacklisted" ?
>>
>> https://github.com/ceph/ceph/blob/master/src/mds/Server.cc#L617
> We could, but it would be fixed in a better way by [1], see [2] for
> context.
>
> [1] https://tracker.ceph.com/issues/47450
> [2] https://github.com/ceph/ceph/pull/37072

Yeah, that fix is cool.

Thanks


> Thanks,
>
>                  Ilya
>

