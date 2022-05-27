Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1794B535729
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 02:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbiE0Ajw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 20:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiE0Aju (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 20:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52386E5284
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653611988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nJa64Pmj/QMtbITeQ9Q0WeAMUpDUFMFmWm9j8kuW5WQ=;
        b=KS+vi37kfIAB8oGPPzT31qjaPhKQF4SNIQ60/HFkJygO/hLurLyre9H1sni69g9v+rrhS0
        +VRXyugpjz31ZfSTrIVmET/MUhrW6xt2sPTaTMpD254Qse7qhNvwpwl6Xl/fG4khvtUqMj
        ooEJlEUAmLevw+zh3h97eoNQgl9pskQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-9e3boXL9PCyfDSdGaBe2fw-1; Thu, 26 May 2022 20:39:37 -0400
X-MC-Unique: 9e3boXL9PCyfDSdGaBe2fw-1
Received: by mail-pl1-f198.google.com with SMTP id e1-20020a17090301c100b0016223b5d1fdso1921490plh.12
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 17:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=nJa64Pmj/QMtbITeQ9Q0WeAMUpDUFMFmWm9j8kuW5WQ=;
        b=P1TOvuWEXvNvUAVgSCiyCe5E6KovRBVFg4cQ2WGc+TOAyPdXXyi05KjslbPjAp9AqV
         o8uHpyWIEej62KoH6/YET9gwMwiTUt98YR6DuO3QVgHM6j6qNGsmUqHUQt+L6jlR8Oub
         qlrR77u2GSbS25Jg+cRKskqsU+T/OQUSLPjKmoidYXzayXj8W0sWyE1PPAoI7hsqIe0R
         qsUoCXoRgSfIjQt0eeEmYp0RHSxyRzdSNIM4fHx444ItnYLwmGAbTIE33b//ACno/L6/
         +24oWhocw2SBAUUNECnoy6r+Mw60eGBRo46Xat7qp7x+IX7bgjDpbhm+q3qZZJP495xX
         ky4A==
X-Gm-Message-State: AOAM532pDE9L9fG7Dm4dgnQfgCAQmD7Ze+rR5xJ6r3k/RJ+A3SaYX+/d
        GIOdtggPyOOxG+QjGG/RQo1wL2QQEN94sjea3QC5wg1gN+hYhGVBClBPG5OSIoTMDlWiKU1pGRV
        aG0kgPRaCT/E4+VAic43TVnQMYIy6a8gdvOAZtNLbIgRt9vV/jsJkXSS5TcxkQVHvIQ6m34s=
X-Received: by 2002:a17:902:ec8f:b0:163:3142:e0dd with SMTP id x15-20020a170902ec8f00b001633142e0ddmr12690235plg.40.1653611975615;
        Thu, 26 May 2022 17:39:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyukLivkuxYrtbrWyrM7pKhlhyoGaXLhlbit5XZGJ2Gjp0akEGWDA+i66PdYhJvQ44B4M0EcA==
X-Received: by 2002:a17:902:ec8f:b0:163:3142:e0dd with SMTP id x15-20020a170902ec8f00b001633142e0ddmr12690214plg.40.1653611975187;
        Thu, 26 May 2022 17:39:35 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l24-20020a17090aaa9800b001e0c1044ceasm240791pjq.43.2022.05.26.17.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 17:39:34 -0700 (PDT)
Subject: Re: [PATCH v2] libceph: drop last_piece flag from
 ceph_msg_data_cursor
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220525101100.7167-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0a7735e8-5bc5-6277-1c89-fe3c92f6dc01@redhat.com>
Date:   Fri, 27 May 2022 08:39:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220525101100.7167-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/25/22 6:11 PM, Jeff Layton wrote:
> ceph_msg_data_next is always passed a NULL pointer for this field. Some
> of the "next" operations look at it in order to determine the length,
> but we can just take the min of the data on the page or cursor->resid.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   include/linux/ceph/messenger.h |  4 +---
>   net/ceph/messenger.c           | 40 +++++-----------------------------
>   net/ceph/messenger_v1.c        |  6 ++---
>   net/ceph/messenger_v2.c        |  2 +-
>   4 files changed, 10 insertions(+), 42 deletions(-)
>
> v2: use min_t(size_t, ...) for the length calculations, as noted by the
>      kernel test robot.
>
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index e7f2fb2fc207..99c1726be6ee 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -207,7 +207,6 @@ struct ceph_msg_data_cursor {
>   
>   	struct ceph_msg_data	*data;		/* current data item */
>   	size_t			resid;		/* bytes not yet consumed */
> -	bool			last_piece;	/* current is last piece */
>   	bool			need_crc;	/* crc update needed */
>   	union {
>   #ifdef CONFIG_BLOCK
> @@ -498,8 +497,7 @@ void ceph_con_discard_requeued(struct ceph_connection *con, u64 reconnect_seq);
>   void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
>   			       struct ceph_msg *msg, size_t length);
>   struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
> -				size_t *page_offset, size_t *length,
> -				bool *last_piece);
> +				size_t *page_offset, size_t *length);
>   void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes);
>   
>   u32 ceph_crc32c_page(u32 crc, struct page *page, unsigned int page_offset,
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index d3bb656308b4..dfa237fbd5a3 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -728,7 +728,6 @@ static void ceph_msg_data_bio_cursor_init(struct ceph_msg_data_cursor *cursor,
>   		it->iter.bi_size = cursor->resid;
>   
>   	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
> -	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
>   }
>   
>   static struct page *ceph_msg_data_bio_next(struct ceph_msg_data_cursor *cursor,
> @@ -754,10 +753,8 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
>   	cursor->resid -= bytes;
>   	bio_advance_iter(it->bio, &it->iter, bytes);
>   
> -	if (!cursor->resid) {
> -		BUG_ON(!cursor->last_piece);
> +	if (!cursor->resid)
>   		return false;   /* no more data */
> -	}
>   
>   	if (!bytes || (it->iter.bi_size && it->iter.bi_bvec_done &&
>   		       page == bio_iter_page(it->bio, it->iter)))
> @@ -770,9 +767,7 @@ static bool ceph_msg_data_bio_advance(struct ceph_msg_data_cursor *cursor,
>   			it->iter.bi_size = cursor->resid;
>   	}
>   
> -	BUG_ON(cursor->last_piece);
>   	BUG_ON(cursor->resid < bio_iter_len(it->bio, it->iter));
> -	cursor->last_piece = cursor->resid == bio_iter_len(it->bio, it->iter);
>   	return true;
>   }
>   #endif /* CONFIG_BLOCK */
> @@ -788,8 +783,6 @@ static void ceph_msg_data_bvecs_cursor_init(struct ceph_msg_data_cursor *cursor,
>   	cursor->bvec_iter.bi_size = cursor->resid;
>   
>   	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
> -	cursor->last_piece =
> -	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
>   }
>   
>   static struct page *ceph_msg_data_bvecs_next(struct ceph_msg_data_cursor *cursor,
> @@ -815,19 +808,14 @@ static bool ceph_msg_data_bvecs_advance(struct ceph_msg_data_cursor *cursor,
>   	cursor->resid -= bytes;
>   	bvec_iter_advance(bvecs, &cursor->bvec_iter, bytes);
>   
> -	if (!cursor->resid) {
> -		BUG_ON(!cursor->last_piece);
> +	if (!cursor->resid)
>   		return false;   /* no more data */
> -	}
>   
>   	if (!bytes || (cursor->bvec_iter.bi_bvec_done &&
>   		       page == bvec_iter_page(bvecs, cursor->bvec_iter)))
>   		return false;	/* more bytes to process in this segment */
>   
> -	BUG_ON(cursor->last_piece);
>   	BUG_ON(cursor->resid < bvec_iter_len(bvecs, cursor->bvec_iter));
> -	cursor->last_piece =
> -	    cursor->resid == bvec_iter_len(bvecs, cursor->bvec_iter);
>   	return true;
>   }
>   
> @@ -853,7 +841,6 @@ static void ceph_msg_data_pages_cursor_init(struct ceph_msg_data_cursor *cursor,
>   	BUG_ON(page_count > (int)USHRT_MAX);
>   	cursor->page_count = (unsigned short)page_count;
>   	BUG_ON(length > SIZE_MAX - cursor->page_offset);
> -	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
>   }
>   
>   static struct page *
> @@ -868,11 +855,7 @@ ceph_msg_data_pages_next(struct ceph_msg_data_cursor *cursor,
>   	BUG_ON(cursor->page_offset >= PAGE_SIZE);
>   
>   	*page_offset = cursor->page_offset;
> -	if (cursor->last_piece)
> -		*length = cursor->resid;
> -	else
> -		*length = PAGE_SIZE - *page_offset;
> -
> +	*length = min_t(size_t, cursor->resid, PAGE_SIZE - *page_offset);
>   	return data->pages[cursor->page_index];
>   }
>   
> @@ -897,8 +880,6 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
>   
>   	BUG_ON(cursor->page_index >= cursor->page_count);
>   	cursor->page_index++;
> -	cursor->last_piece = cursor->resid <= PAGE_SIZE;
> -
>   	return true;
>   }
>   
> @@ -928,7 +909,6 @@ ceph_msg_data_pagelist_cursor_init(struct ceph_msg_data_cursor *cursor,
>   	cursor->resid = min(length, pagelist->length);
>   	cursor->page = page;
>   	cursor->offset = 0;
> -	cursor->last_piece = cursor->resid <= PAGE_SIZE;
>   }
>   
>   static struct page *
> @@ -948,11 +928,7 @@ ceph_msg_data_pagelist_next(struct ceph_msg_data_cursor *cursor,
>   
>   	/* offset of first page in pagelist is always 0 */
>   	*page_offset = cursor->offset & ~PAGE_MASK;
> -	if (cursor->last_piece)
> -		*length = cursor->resid;
> -	else
> -		*length = PAGE_SIZE - *page_offset;
> -
> +	*length = min_t(size_t, cursor->resid, PAGE_SIZE - *page_offset);
>   	return cursor->page;
>   }
>   
> @@ -985,8 +961,6 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
>   
>   	BUG_ON(list_is_last(&cursor->page->lru, &pagelist->head));
>   	cursor->page = list_next_entry(cursor->page, lru);
> -	cursor->last_piece = cursor->resid <= PAGE_SIZE;
> -
>   	return true;
>   }
>   
> @@ -1044,8 +1018,7 @@ void ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor,
>    * Indicate whether this is the last piece in this data item.
>    */
>   struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
> -				size_t *page_offset, size_t *length,
> -				bool *last_piece)
> +				size_t *page_offset, size_t *length)
>   {
>   	struct page *page;
>   
> @@ -1074,8 +1047,6 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
>   	BUG_ON(*page_offset + *length > PAGE_SIZE);
>   	BUG_ON(!*length);
>   	BUG_ON(*length > cursor->resid);
> -	if (last_piece)
> -		*last_piece = cursor->last_piece;
>   
>   	return page;
>   }
> @@ -1112,7 +1083,6 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
>   	cursor->total_resid -= bytes;
>   
>   	if (!cursor->resid && cursor->total_resid) {
> -		WARN_ON(!cursor->last_piece);
>   		cursor->data++;
>   		__ceph_msg_data_cursor_init(cursor);
>   		new_piece = true;
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 6b014eca3a13..3ddbde87e4d6 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -495,7 +495,7 @@ static int write_partial_message_data(struct ceph_connection *con)
>   			continue;
>   		}
>   
> -		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
> +		page = ceph_msg_data_next(cursor, &page_offset, &length);
>   		if (length == cursor->total_resid)
>   			more = MSG_MORE;
>   		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
> @@ -1008,7 +1008,7 @@ static int read_partial_msg_data(struct ceph_connection *con)
>   			continue;
>   		}
>   
> -		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
> +		page = ceph_msg_data_next(cursor, &page_offset, &length);
>   		ret = ceph_tcp_recvpage(con->sock, page, page_offset, length);
>   		if (ret <= 0) {
>   			if (do_datacrc)
> @@ -1050,7 +1050,7 @@ static int read_partial_msg_data_bounce(struct ceph_connection *con)
>   			continue;
>   		}
>   
> -		page = ceph_msg_data_next(cursor, &off, &len, NULL);
> +		page = ceph_msg_data_next(cursor, &off, &len);
>   		ret = ceph_tcp_recvpage(con->sock, con->bounce_page, 0, len);
>   		if (ret <= 0) {
>   			con->in_data_crc = crc;
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index c6e5bfc717d5..cc8ff81a50b7 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -862,7 +862,7 @@ static void get_bvec_at(struct ceph_msg_data_cursor *cursor,
>   		ceph_msg_data_advance(cursor, 0);
>   
>   	/* get a piece of data, cursor isn't advanced */
> -	page = ceph_msg_data_next(cursor, &off, &len, NULL);
> +	page = ceph_msg_data_next(cursor, &off, &len);
>   
>   	bv->bv_page = page;
>   	bv->bv_offset = off;

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


