Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626345B440
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGAFfE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:35:04 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:24695 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfGAFfD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:35:03 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAnkXRKmhldw37wAA--.1242S2;
        Mon, 01 Jul 2019 13:29:47 +0800 (CST)
Subject: Re: [PATCH 16/20] libceph: change ceph_osdc_call() to take page
 vector for response
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-17-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A4A.2040902@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-17-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAnkXRKmhldw37wAA--.1242S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr4UCr4ftr1rCr1rWF15Jwb_yoWrKF47pF
        ZrJ3WYyay7JF1aga12yFs5ZF40kw4qyayIgryUJF1fCFnIyFZFqF1vkF9Iv3s7KF47CFsx
        KF4qvF48Ja15tF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR78n7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbidAvkeln5exZUxwAAs-
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> This will be used for loading object map.  rbd_obj_read_sync() isn't
> suitable because object map must be accessed through class methods.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c             |  8 ++++----
>   include/linux/ceph/osd_client.h |  2 +-
>   net/ceph/cls_lock_client.c      |  2 +-
>   net/ceph/osd_client.c           | 10 +++++-----
>   4 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index fd3f248ba9c2..c9f88b0cb730 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4072,7 +4072,7 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
>   
>   	ret = ceph_osdc_call(osdc, oid, oloc, RBD_DRV_NAME, method_name,
>   			     CEPH_OSD_FLAG_READ, req_page, outbound_size,
> -			     reply_page, &inbound_size);
> +			     &reply_page, &inbound_size);
>   	if (!ret) {
>   		memcpy(inbound, page_address(reply_page), inbound_size);
>   		ret = inbound_size;
> @@ -5098,7 +5098,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
>   
>   	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>   			     "rbd", "parent_get", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>   	if (ret)
>   		return ret == -EOPNOTSUPP ? 1 : ret;
>   
> @@ -5110,7 +5110,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
>   
>   	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>   			     "rbd", "parent_overlap_get", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>   	if (ret)
>   		return ret;
>   
> @@ -5141,7 +5141,7 @@ static int __get_parent_info_legacy(struct rbd_device *rbd_dev,
>   
>   	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>   			     "rbd", "get_parent", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>   	if (ret)
>   		return ret;
>   
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 2294f963dab7..edb191c40a5c 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -497,7 +497,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>   		   const char *class, const char *method,
>   		   unsigned int flags,
>   		   struct page *req_page, size_t req_len,
> -		   struct page *resp_page, size_t *resp_len);
> +		   struct page **resp_pages, size_t *resp_len);
>   
>   extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
>   			       struct ceph_vino vino,
> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> index 4cc28541281b..56bbfe01e3ac 100644
> --- a/net/ceph/cls_lock_client.c
> +++ b/net/ceph/cls_lock_client.c
> @@ -360,7 +360,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
>   	dout("%s lock_name %s\n", __func__, lock_name);
>   	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "get_info",
>   			     CEPH_OSD_FLAG_READ, get_info_op_page,
> -			     get_info_op_buf_size, reply_page, &reply_len);
> +			     get_info_op_buf_size, &reply_page, &reply_len);
>   
>   	dout("%s: status %d\n", __func__, ret);
>   	if (ret >= 0) {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9a8eca5eda65..cc2bf296583d 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5044,12 +5044,12 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>   		   const char *class, const char *method,
>   		   unsigned int flags,
>   		   struct page *req_page, size_t req_len,
> -		   struct page *resp_page, size_t *resp_len)
> +		   struct page **resp_pages, size_t *resp_len)
>   {
>   	struct ceph_osd_request *req;
>   	int ret;
>   
> -	if (req_len > PAGE_SIZE || (resp_page && *resp_len > PAGE_SIZE))
> +	if (req_len > PAGE_SIZE)
>   		return -E2BIG;
>   
>   	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_NOIO);
> @@ -5067,8 +5067,8 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>   	if (req_page)
>   		osd_req_op_cls_request_data_pages(req, 0, &req_page, req_len,
>   						  0, false, false);
> -	if (resp_page)
> -		osd_req_op_cls_response_data_pages(req, 0, &resp_page,
> +	if (resp_pages)
> +		osd_req_op_cls_response_data_pages(req, 0, resp_pages,
>   						   *resp_len, 0, false, false);
>   
>   	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
> @@ -5079,7 +5079,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>   	ret = ceph_osdc_wait_request(osdc, req);
>   	if (ret >= 0) {
>   		ret = req->r_ops[0].rval;
> -		if (resp_page)
> +		if (resp_pages)
>   			*resp_len = req->r_ops[0].outdata_len;
>   	}
>   


