Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6AD545B5D
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 06:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiFJExe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 00:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240448AbiFJExd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 00:53:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 069E938EB8F
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 21:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654836811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ZVVlnKWTofbxqyFA8L6Eu6YY1nZo3lJSkRj/7WWZHA=;
        b=Js04dc1kPqCXSQztxXJxOQL0XG6YNtYwDIiWFqhsYdhvCC+9YZ0ZlPH+18iZXE2jc5UKyB
        5Zg19mI7J0lu9ADSJJRA4NO9YqJ6GrHAFOkviKlV1gwBayOEmZctXGy+2laCm2lUJpiji4
        BcYk1qQXBQ0iEVMZ6AbNA12D3lbiy7s=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-2Q5LlmSrNGW6iHGseFluFw-1; Fri, 10 Jun 2022 00:53:30 -0400
X-MC-Unique: 2Q5LlmSrNGW6iHGseFluFw-1
Received: by mail-pj1-f70.google.com with SMTP id ob5-20020a17090b390500b001e2f03294a7so817751pjb.8
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 21:53:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6ZVVlnKWTofbxqyFA8L6Eu6YY1nZo3lJSkRj/7WWZHA=;
        b=3u8v/y/7OB/43i6HZai48K06Y5yjDMzhPJJZWdcCTiUU6mygnIVc7ylhCVXATNsrC8
         mzynSX3ffYGpsCfwVF29LWYVpQeqQvw/5yN43L2StRqUZ8zKCgwkLKBCmcId4RhpRKP0
         vU+DjjC2y/4InKqJ6wyhEIKsbTPfAvciSegSTwdgflJjaVg7v/B05503yyezBh6ePAwY
         RQHzkzsS98CHHgm3c5yQlxUFcVgkK0LI4WLA0wrW7QSKOOcTcj6yg4zwmtpG5+Wk/ECP
         6yGiWKoDPyztua+tM1itVNJxu4vVRPHITbVCppeMOumgo8uvCqkqKwBrvoDtYGKjg2Bo
         uwyA==
X-Gm-Message-State: AOAM532fuThobuSw1QN+0/7/2lHxeVfp2UmGritJ13Kn2jHpavFjeGMF
        7PGElGgVndYaqtLqhoVxp+Ojfkl2C8FY/W/y5rMl8jRnhAwWCrlhm56InW5ZWU0pBLGF26+y0Bz
        fe5/R0weN/oaXjWmwYf0Gx86XdjFKiFW2o1pIvaHp3O9RX/TG7tuJ/OAWjew4qbHXNJBikIE=
X-Received: by 2002:a17:903:28c:b0:167:6127:ed99 with SMTP id j12-20020a170903028c00b001676127ed99mr31186513plr.94.1654836808101;
        Thu, 09 Jun 2022 21:53:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwokhqJwpMf/UT8qTLoro0xLdGCA6qOerincgcTMXsLrKYTZaFc7gPBKWZVTxwzrpXMH4xJcA==
X-Received: by 2002:a17:903:28c:b0:167:6127:ed99 with SMTP id j12-20020a170903028c00b001676127ed99mr31186492plr.94.1654836807620;
        Thu, 09 Jun 2022 21:53:27 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902d34500b0015ef27092aasm17664910plk.190.2022.06.09.21.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 21:53:26 -0700 (PDT)
Subject: Re: [PATCH 1/2] libceph: add new iov_iter-based ceph_msg_data_type
 and ceph_osd_data_type
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, dhowells@redhat.com, ceph-devel@vger.kernel.org
References: <20220609193423.167942-1-jlayton@kernel.org>
 <20220609193423.167942-2-jlayton@kernel.org>
 <f6074a43e6ebeced5e53578c211b64dd80f7bb3a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d8ea84c5-11b6-47df-1712-1c9c621be7bd@redhat.com>
Date:   Fri, 10 Jun 2022 12:53:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <f6074a43e6ebeced5e53578c211b64dd80f7bb3a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/10/22 3:39 AM, Jeff Layton wrote:
> On Thu, 2022-06-09 at 15:34 -0400, Jeff Layton wrote:
>> Add an iov_iter to the unions in ceph_msg_data and ceph_msg_data_cursor.
>> Instead of requiring a list of pages or bvecs, we can just use an
>> iov_iter directly, and avoid extra allocations.
>>
>> Note that we do assume that the pages represented by the iter are pinned
>> such that they shouldn't incur page faults.
>>
>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   include/linux/ceph/messenger.h  |  5 +++
>>   include/linux/ceph/osd_client.h |  4 +++
>>   net/ceph/messenger.c            | 64 +++++++++++++++++++++++++++++++++
>>   net/ceph/osd_client.c           | 27 ++++++++++++++
>>   4 files changed, 100 insertions(+)
>>
>> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
>> index 9fd7255172ad..c259021ca4a8 100644
>> --- a/include/linux/ceph/messenger.h
>> +++ b/include/linux/ceph/messenger.h
>> @@ -123,6 +123,7 @@ enum ceph_msg_data_type {
>>   	CEPH_MSG_DATA_BIO,	/* data source/destination is a bio list */
>>   #endif /* CONFIG_BLOCK */
>>   	CEPH_MSG_DATA_BVECS,	/* data source/destination is a bio_vec array */
>> +	CEPH_MSG_DATA_ITER,	/* data source/destination is an iov_iter */
>>   };
>>   
>>   #ifdef CONFIG_BLOCK
>> @@ -224,6 +225,7 @@ struct ceph_msg_data {
>>   			bool		own_pages;
>>   		};
>>   		struct ceph_pagelist	*pagelist;
>> +		struct iov_iter		iter;
>>   	};
>>   };
>>   
>> @@ -248,6 +250,7 @@ struct ceph_msg_data_cursor {
>>   			struct page	*page;		/* page from list */
>>   			size_t		offset;		/* bytes from list */
>>   		};
>> +		struct iov_iter		iov_iter;
>>   	};
>>   };
>>   
>> @@ -605,6 +608,8 @@ void ceph_msg_data_add_bio(struct ceph_msg *msg, struct ceph_bio_iter *bio_pos,
>>   #endif /* CONFIG_BLOCK */
>>   void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
>>   			     struct ceph_bvec_iter *bvec_pos);
>> +void ceph_msg_data_add_iter(struct ceph_msg *msg,
>> +			    struct iov_iter *iter);
>>   
>>   struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
>>   			       gfp_t flags, bool can_fail);
>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
>> index 6ec3cb2ac457..ef0ad534b6c5 100644
>> --- a/include/linux/ceph/osd_client.h
>> +++ b/include/linux/ceph/osd_client.h
>> @@ -108,6 +108,7 @@ enum ceph_osd_data_type {
>>   	CEPH_OSD_DATA_TYPE_BIO,
>>   #endif /* CONFIG_BLOCK */
>>   	CEPH_OSD_DATA_TYPE_BVECS,
>> +	CEPH_OSD_DATA_TYPE_ITER,
>>   };
>>   
>>   struct ceph_osd_data {
>> @@ -131,6 +132,7 @@ struct ceph_osd_data {
>>   			struct ceph_bvec_iter	bvec_pos;
>>   			u32			num_bvecs;
>>   		};
>> +		struct iov_iter		iter;
>>   	};
>>   };
>>   
>> @@ -501,6 +503,8 @@ void osd_req_op_extent_osd_data_bvecs(struct ceph_osd_request *osd_req,
>>   void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
>>   					 unsigned int which,
>>   					 struct ceph_bvec_iter *bvec_pos);
>> +void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
>> +				unsigned int which, struct iov_iter *iter);
>>   
>>   extern void osd_req_op_cls_request_data_pagelist(struct ceph_osd_request *,
>>   					unsigned int which,
>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
>> index 6056c8f7dd4c..cea0d75dfc49 100644
>> --- a/net/ceph/messenger.c
>> +++ b/net/ceph/messenger.c
>> @@ -964,6 +964,48 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
>>   	return true;
>>   }
>>   
>> +static void ceph_msg_data_iter_cursor_init(struct ceph_msg_data_cursor *cursor,
>> +					size_t length)
>> +{
>> +	struct ceph_msg_data *data = cursor->data;
>> +
>> +	cursor->iov_iter = data->iter;
>> +	iov_iter_truncate(&cursor->iov_iter, length);
>> +	cursor->resid = iov_iter_count(&cursor->iov_iter);
>> +}
>> +
>> +static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
>> +						size_t *page_offset,
>> +						size_t *length)
>> +{
>> +	struct page *page;
>> +	ssize_t len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
>> +					 1, page_offset);
>> +
>> +	BUG_ON(len < 0);
>> +
>> +	/*
>> +	 * The assumption is that the pages represented by the iov_iter are
>> +	 * pinned, with the references held by the upper-level callers, or
>> +	 * by virtue of being under writeback. Given that, we should be
>> +	 * safe to put the page reference here and still return the pointer.
>> +	 */
>> +	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
>> +	put_page(page);
>> +	*length = min_t(size_t, len, cursor->resid);
>> +	return page;
>> +}
>> +
>> +static bool ceph_msg_data_iter_advance(struct ceph_msg_data_cursor *cursor,
>> +					size_t bytes)
>> +{
>> +	BUG_ON(bytes > cursor->resid);
>> +	cursor->resid -= bytes;
>> +	iov_iter_advance(&cursor->iov_iter, bytes);
>> +
>> +	return cursor->resid;
>> +}
>> +
>>   /*
>>    * Message data is handled (sent or received) in pieces, where each
>>    * piece resides on a single page.  The network layer might not
>> @@ -991,6 +1033,9 @@ static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
>>   	case CEPH_MSG_DATA_BVECS:
>>   		ceph_msg_data_bvecs_cursor_init(cursor, length);
>>   		break;
>> +	case CEPH_MSG_DATA_ITER:
>> +		ceph_msg_data_iter_cursor_init(cursor, length);
>> +		break;
>>   	case CEPH_MSG_DATA_NONE:
>>   	default:
>>   		/* BUG(); */
>> @@ -1038,6 +1083,9 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
>>   	case CEPH_MSG_DATA_BVECS:
>>   		page = ceph_msg_data_bvecs_next(cursor, page_offset, length);
>>   		break;
>> +	case CEPH_MSG_DATA_ITER:
>> +		page = ceph_msg_data_iter_next(cursor, page_offset, length);
>> +		break;
>>   	case CEPH_MSG_DATA_NONE:
>>   	default:
>>   		page = NULL;
>> @@ -1076,6 +1124,9 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
>>   	case CEPH_MSG_DATA_BVECS:
>>   		new_piece = ceph_msg_data_bvecs_advance(cursor, bytes);
>>   		break;
>> +	case CEPH_MSG_DATA_ITER:
>> +		new_piece = ceph_msg_data_iter_advance(cursor, bytes);
>> +		break;
>>   	case CEPH_MSG_DATA_NONE:
>>   	default:
>>   		BUG();
>> @@ -1874,6 +1925,19 @@ void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
>>   }
>>   EXPORT_SYMBOL(ceph_msg_data_add_bvecs);
>>   
>> +void ceph_msg_data_add_iter(struct ceph_msg *msg,
>> +			    struct iov_iter *iter)
>> +{
>> +	struct ceph_msg_data *data;
>> +
>> +	data = ceph_msg_data_add(msg);
>> +	data->type = CEPH_MSG_DATA_ITER;
>> +	data->iter = *iter;
>> +
>> +	msg->data_length += iov_iter_count(&data->iter);
>> +}
>> +EXPORT_SYMBOL(ceph_msg_data_add_iter);
> I don't think this EXPORT_SYMBOL is actually needed. Nothing outside
> libceph calls this. I've fixed this up in my tree, and can send a v2, or
> you can just remove that line before merging.

This patch series looks good to me.

I will merge it by fixing this at the same time.

Thanks Jeff.

-- Xiubo


>> +
>>   /*
>>    * construct a new message with given type, size
>>    * the new msg has a ref count of 1.
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 75761537c644..2a7e46524e71 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -171,6 +171,13 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
>>   	osd_data->num_bvecs = num_bvecs;
>>   }
>>   
>> +static void ceph_osd_iter_init(struct ceph_osd_data *osd_data,
>> +			       struct iov_iter *iter)
>> +{
>> +	osd_data->type = CEPH_OSD_DATA_TYPE_ITER;
>> +	osd_data->iter = *iter;
>> +}
>> +
>>   static struct ceph_osd_data *
>>   osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
>>   {
>> @@ -264,6 +271,22 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
>>   }
>>   EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvec_pos);
>>   
>> +/**
>> + * osd_req_op_extent_osd_iter - Set up an operation with an iterator buffer
>> + * @osd_req: The request to set up
>> + * @which: ?
>> + * @iter: The buffer iterator
>> + */
>> +void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
>> +				unsigned int which, struct iov_iter *iter)
>> +{
>> +	struct ceph_osd_data *osd_data;
>> +
>> +	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
>> +	ceph_osd_iter_init(osd_data, iter);
>> +}
>> +EXPORT_SYMBOL(osd_req_op_extent_osd_iter);
>> +
>>   static void osd_req_op_cls_request_info_pagelist(
>>   			struct ceph_osd_request *osd_req,
>>   			unsigned int which, struct ceph_pagelist *pagelist)
>> @@ -346,6 +369,8 @@ static u64 ceph_osd_data_length(struct ceph_osd_data *osd_data)
>>   #endif /* CONFIG_BLOCK */
>>   	case CEPH_OSD_DATA_TYPE_BVECS:
>>   		return osd_data->bvec_pos.iter.bi_size;
>> +	case CEPH_OSD_DATA_TYPE_ITER:
>> +		return iov_iter_count(&osd_data->iter);
>>   	default:
>>   		WARN(true, "unrecognized data type %d\n", (int)osd_data->type);
>>   		return 0;
>> @@ -954,6 +979,8 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
>>   #endif
>>   	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_BVECS) {
>>   		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos);
>> +	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_ITER) {
>> +		ceph_msg_data_add_iter(msg, &osd_data->iter);
>>   	} else {
>>   		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_NONE);
>>   	}

