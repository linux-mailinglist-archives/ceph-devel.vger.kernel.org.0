Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0215628BF
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 04:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiGACJP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jun 2022 22:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGACJO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jun 2022 22:09:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBB502AE15
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 19:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656641350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mc43gNVW++KZFC+W1unw9W+e4kjVsG52oHEwHJnhQNU=;
        b=A3p5MYRSkSG+ESq2qFiMXA+pqFphU9sOEp/O9GNfusA1LQ//WkDNooBAYL6rD5cza/Xqpm
        g9N3NAmHWASWj6vAvOEjiJuSNWk0cQ2eDgLxLht/8tyFMFbgXgj07hg9Ko/9s1wseZpmB9
        cuJPk6HdqC+U8b3f16G9XIMKb7BYS0E=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-mekLY4NOOp2pOaAa22MswQ-1; Thu, 30 Jun 2022 22:09:09 -0400
X-MC-Unique: mekLY4NOOp2pOaAa22MswQ-1
Received: by mail-pg1-f198.google.com with SMTP id a15-20020a65604f000000b00401a9baf7d5so565681pgp.0
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 19:09:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mc43gNVW++KZFC+W1unw9W+e4kjVsG52oHEwHJnhQNU=;
        b=ncuiWd4BsPpkdPSmkaxMqnQfoVLe2ScTLO7WUUEEIu/HjxTZWlbv+1oPSA4Z8NsTJT
         QP+1uHAWnCg36+hikR9dwJy1ePVofhJ6DLvVAjq0zZIXOL2MpoCBJ2XkgUI126yFkwG5
         wfMZF/YgBOfaN/llmxf1gvVBxkoSgXLYqQJX+uz8Z9ceCSW7TrgrLWCNeiAHUs2qGOdw
         ZOfXSDAULw4rZJx8pLa0nCZ+F1ur9jPzl4U4dZtg9Wau4dZEJT5Ze9d1KKvcbS9Ibswb
         h4FO+Nck2Mlpt4xXGPy5wB7fqmCSzyJO4urOsLNnOJBmi4BcQ5q8VDBDOgzLmaBKJBNl
         Re2Q==
X-Gm-Message-State: AJIora8cFJQ1W0/uF/UICDr/fECxB+5SaBAHEVzOlJGYVo1jGprwKFAj
        6KUmn0zWhLFObTzVCmt5rZ/Kgz8tzcu4URA1u1nNljIdMekBY+G+cohoSo8NrrbVULoXY9hpCLP
        gk/L7LbFDf3ITWA1a3V3nHDrbQdrLD2ymnVZU3VbJ2Cy46vU6zfIMVPbgburooLCqYPG8EkA=
X-Received: by 2002:a17:90a:d993:b0:1ec:db00:6519 with SMTP id d19-20020a17090ad99300b001ecdb006519mr15679489pjv.106.1656641347591;
        Thu, 30 Jun 2022 19:09:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t27yFOWsTQSE9dTGVYXywZORc9sDeILETKIZ83UxleP3EBH5lrx+YntAC0uYYuOX6J2xyptw==
X-Received: by 2002:a17:90a:d993:b0:1ec:db00:6519 with SMTP id d19-20020a17090ad99300b001ecdb006519mr15679448pjv.106.1656641347175;
        Thu, 30 Jun 2022 19:09:07 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gz4-20020a17090b0ec400b001ec4f258028sm5207932pjb.55.2022.06.30.19.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 19:09:06 -0700 (PDT)
Subject: Re: [PATCH] libceph: clean up ceph_osdc_start_request prototype
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220630202150.653547-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <21be3084-f8f3-120c-be07-086c8deffd3d@redhat.com>
Date:   Fri, 1 Jul 2022 10:09:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220630202150.653547-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/1/22 4:21 AM, Jeff Layton wrote:
> This function always returns 0, and ignores the nofail boolean. Drop the
> nofail argument, make the function void return and fix up the callers.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   drivers/block/rbd.c             |  6 +++---
>   fs/ceph/addr.c                  | 32 ++++++++++++--------------------
>   fs/ceph/file.c                  | 32 +++++++++++++-------------------
>   include/linux/ceph/osd_client.h |  5 ++---
>   net/ceph/osd_client.c           | 15 ++++++---------
>   5 files changed, 36 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 91e541aa1f64..a8af0329ab77 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1297,7 +1297,7 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
>   	dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
>   	     __func__, osd_req, obj_req, obj_req->ex.oe_objno,
>   	     obj_req->ex.oe_off, obj_req->ex.oe_len);
> -	ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
> +	ceph_osdc_start_request(osd_req->r_osdc, osd_req);
>   }
>   
>   /*
> @@ -2081,7 +2081,7 @@ static int rbd_object_map_update(struct rbd_obj_request *obj_req, u64 snap_id,
>   	if (ret)
>   		return ret;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	return 0;
>   }
>   
> @@ -4768,7 +4768,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
>   	if (ret)
>   		goto out_req;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	ret = ceph_osdc_wait_request(osdc, req);
>   	if (ret >= 0)
>   		ceph_copy_from_page_vector(pages, buf, 0, ret);
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index fe6147f20dee..66dc7844fcc6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -357,9 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>   	req->r_inode = inode;
>   	ihold(inode);
>   
> -	err = ceph_osdc_start_request(req->r_osdc, req, false);
> -	if (err)
> -		iput(inode);
> +	ceph_osdc_start_request(req->r_osdc, req);
>   out:
>   	ceph_osdc_put_request(req);
>   	if (err)
> @@ -633,9 +631,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
>   
>   	req->r_mtime = inode->i_mtime;
> -	err = ceph_osdc_start_request(osdc, req, true);
> -	if (!err)
> -		err = ceph_osdc_wait_request(osdc, req);
> +	ceph_osdc_start_request(osdc, req);
> +	err = ceph_osdc_wait_request(osdc, req);
>   
>   	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>   				  req->r_end_latency, len, err);
> @@ -1163,8 +1160,7 @@ static int ceph_writepages_start(struct address_space *mapping,
>   		}
>   
>   		req->r_mtime = inode->i_mtime;
> -		rc = ceph_osdc_start_request(&fsc->client->osdc, req, true);
> -		BUG_ON(rc);
> +		ceph_osdc_start_request(&fsc->client->osdc, req);
>   		req = NULL;
>   
>   		wbc->nr_to_write -= i;
> @@ -1707,9 +1703,8 @@ int ceph_uninline_data(struct file *file)
>   	}
>   
>   	req->r_mtime = inode->i_mtime;
> -	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> -	if (!err)
> -		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +	ceph_osdc_start_request(&fsc->client->osdc, req);
> +	err = ceph_osdc_wait_request(&fsc->client->osdc, req);
>   	ceph_osdc_put_request(req);
>   	if (err < 0)
>   		goto out_unlock;
> @@ -1750,9 +1745,8 @@ int ceph_uninline_data(struct file *file)
>   	}
>   
>   	req->r_mtime = inode->i_mtime;
> -	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> -	if (!err)
> -		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +	ceph_osdc_start_request(&fsc->client->osdc, req);
> +	err = ceph_osdc_wait_request(&fsc->client->osdc, req);
>   
>   	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>   				  req->r_end_latency, len, err);
> @@ -1923,15 +1917,13 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
>   
>   	osd_req_op_raw_data_in_pages(rd_req, 0, pages, PAGE_SIZE,
>   				     0, false, true);
> -	err = ceph_osdc_start_request(&fsc->client->osdc, rd_req, false);
> +	ceph_osdc_start_request(&fsc->client->osdc, rd_req);
>   
>   	wr_req->r_mtime = ci->netfs.inode.i_mtime;
> -	err2 = ceph_osdc_start_request(&fsc->client->osdc, wr_req, false);
> +	ceph_osdc_start_request(&fsc->client->osdc, wr_req);
>   
> -	if (!err)
> -		err = ceph_osdc_wait_request(&fsc->client->osdc, rd_req);
> -	if (!err2)
> -		err2 = ceph_osdc_wait_request(&fsc->client->osdc, wr_req);
> +	err = ceph_osdc_wait_request(&fsc->client->osdc, rd_req);
> +	err2 = ceph_osdc_wait_request(&fsc->client->osdc, wr_req);
>   
>   	if (err >= 0 || err == -ENOENT)
>   		have |= POOL_READ;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0eb4a02175ad..296fd1c7ece8 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1008,9 +1008,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   			}
>   		}
>   
> -		ret = ceph_osdc_start_request(osdc, req, false);
> -		if (!ret)
> -			ret = ceph_osdc_wait_request(osdc, req);
> +		ceph_osdc_start_request(osdc, req);
> +		ret = ceph_osdc_wait_request(osdc, req);
>   
>   		ceph_update_read_metrics(&fsc->mdsc->metric,
>   					 req->r_start_latency,
> @@ -1282,7 +1281,7 @@ static void ceph_aio_retry_work(struct work_struct *work)
>   	req->r_inode = inode;
>   	req->r_priv = aio_req;
>   
> -	ret = ceph_osdc_start_request(req->r_osdc, req, false);
> +	ceph_osdc_start_request(req->r_osdc, req);
>   out:
>   	if (ret < 0) {
>   		req->r_result = ret;
> @@ -1429,9 +1428,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>   			continue;
>   		}
>   
> -		ret = ceph_osdc_start_request(req->r_osdc, req, false);
> -		if (!ret)
> -			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +		ceph_osdc_start_request(req->r_osdc, req);
> +		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
>   
>   		if (write)
>   			ceph_update_write_metrics(metric, req->r_start_latency,
> @@ -1497,8 +1495,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
>   					       r_private_item);
>   			list_del_init(&req->r_private_item);
>   			if (ret >= 0)
> -				ret = ceph_osdc_start_request(req->r_osdc,
> -							      req, false);
> +				ceph_osdc_start_request(req->r_osdc, req);
>   			if (ret < 0) {
>   				req->r_result = ret;
>   				ceph_aio_complete_req(req);
> @@ -1611,9 +1608,8 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   						false, true);
>   
>   		req->r_mtime = mtime;
> -		ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> -		if (!ret)
> -			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +		ceph_osdc_start_request(&fsc->client->osdc, req);
> +		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
>   
>   		ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>   					  req->r_end_latency, len, ret);
> @@ -2077,12 +2073,10 @@ static int ceph_zero_partial_object(struct inode *inode,
>   	}
>   
>   	req->r_mtime = inode->i_mtime;
> -	ret = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> -	if (!ret) {
> -		ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> -		if (ret == -ENOENT)
> -			ret = 0;
> -	}
> +	ceph_osdc_start_request(&fsc->client->osdc, req);
> +	ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +	if (ret == -ENOENT)
> +		ret = 0;
>   	ceph_osdc_put_request(req);
>   
>   out:
> @@ -2384,7 +2378,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>   		if (IS_ERR(req))
>   			ret = PTR_ERR(req);
>   		else {
> -			ceph_osdc_start_request(osdc, req, false);
> +			ceph_osdc_start_request(osdc, req);
>   			ret = ceph_osdc_wait_request(osdc, req);
>   			ceph_update_copyfrom_metrics(&fsc->mdsc->metric,
>   						     req->r_start_latency,
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 6ec3cb2ac457..8cfa650def2c 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -572,9 +572,8 @@ static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op)
>   extern void ceph_osdc_get_request(struct ceph_osd_request *req);
>   extern void ceph_osdc_put_request(struct ceph_osd_request *req);
>   
> -extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
> -				   struct ceph_osd_request *req,
> -				   bool nofail);
> +void ceph_osdc_start_request(struct ceph_osd_client *osdc,
> +				struct ceph_osd_request *req);
>   extern void ceph_osdc_cancel_request(struct ceph_osd_request *req);
>   extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
>   				  struct ceph_osd_request *req);
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 75761537c644..fe674c4e943f 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4615,15 +4615,12 @@ static void handle_watch_notify(struct ceph_osd_client *osdc,
>   /*
>    * Register request, send initial attempt.
>    */
> -int ceph_osdc_start_request(struct ceph_osd_client *osdc,
> -			    struct ceph_osd_request *req,
> -			    bool nofail)
> +void ceph_osdc_start_request(struct ceph_osd_client *osdc,
> +			     struct ceph_osd_request *req)
>   {
>   	down_read(&osdc->lock);
>   	submit_request(req, false);
>   	up_read(&osdc->lock);
> -
> -	return 0;
>   }
>   EXPORT_SYMBOL(ceph_osdc_start_request);
>   
> @@ -4793,7 +4790,7 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
>   	if (ret)
>   		goto out_put_req;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	linger_cancel(lreq);
>   	linger_put(lreq);
>   	ret = wait_request_timeout(req, opts->mount_timeout);
> @@ -4864,7 +4861,7 @@ int ceph_osdc_notify_ack(struct ceph_osd_client *osdc,
>   	if (ret)
>   		goto out_put_req;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	ret = ceph_osdc_wait_request(osdc, req);
>   
>   out_put_req:
> @@ -5080,7 +5077,7 @@ int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
>   	if (ret)
>   		goto out_put_req;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	ret = ceph_osdc_wait_request(osdc, req);
>   	if (ret >= 0) {
>   		void *p = page_address(pages[0]);
> @@ -5157,7 +5154,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>   	if (ret)
>   		goto out_put_req;
>   
> -	ceph_osdc_start_request(osdc, req, false);
> +	ceph_osdc_start_request(osdc, req);
>   	ret = ceph_osdc_wait_request(osdc, req);
>   	if (ret >= 0) {
>   		ret = req->r_ops[0].rval;

Looks good.

Will merge to the testing branch and test it.

Thanks Jeff!

-- Xiubo

