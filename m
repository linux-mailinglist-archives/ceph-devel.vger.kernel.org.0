Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4099B51BDFD
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357064AbiEELb2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 07:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357342AbiEELbZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 07:31:25 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D34C54199
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 04:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651750062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DZlKXALjnqp9gGuyyz9icxc9rWQfQ1va1FF0Eh4Fw8=;
        b=IqjwNmzIxtl2sRs1iM8ZI8J2DMuABxTYTmrNH3O6BusnAkioPUMZK5cj6tDk9fcI0gD/0n
        1ZWFJEdcBHtgCtKA/ZJoHo54hcd5OyTSPWrDhKJJUCt/aDgPsmNZGlxiVhnfCuL9i3nmkW
        un4XkDsyPAtOi8XJ5oMgTQ+XznblNws=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-tM4luI6xMXSDfXT5nyWs6Q-1; Thu, 05 May 2022 07:27:41 -0400
X-MC-Unique: tM4luI6xMXSDfXT5nyWs6Q-1
Received: by mail-pj1-f71.google.com with SMTP id a24-20020a17090a8c1800b001d98eff7882so1838797pjo.8
        for <ceph-devel@vger.kernel.org>; Thu, 05 May 2022 04:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8DZlKXALjnqp9gGuyyz9icxc9rWQfQ1va1FF0Eh4Fw8=;
        b=p8TRbpstPDziFhrZeykUtVhYkuEZ1FSzIcHmyfWacnBeFQb6SUb9PySifUsZL5KwU+
         5/lCrRlfJcQQBV2bBaXSaX11v/hIMuOmsRxqpkNfnavok1mmDyrMTdaO8+e+0EtMnK6i
         AKvSGSPN5EbeWYl0gK8re45tFYZB24yd/2PeyGB2qHe7vIzuGx1rlKN8VE7E3qlYqyYl
         jkLyOXJDmNOqadkCLPKXLvkzcMQzoANgQkHMET4fakjWYjeqWnURiWjgnXNs9pe/GApq
         7uVD3LFYovA32GY3MGn9SkAD3hyyco6+MfWEBQo4kClw4+5F0D3/ysXiu4KQXH5Pozue
         qdAg==
X-Gm-Message-State: AOAM532c1T27KHmJurFm/M5G7s8ltQe2YxCY4nMzvcvoZ+kb70+CTPqX
        TEWdsJULg7rC4W+3ldIuOOeUzD8BCCRX3v2uNjlzGXSw4kYbTGNvsWbD/+mvNTmcQRXkLZ2P/yt
        1UqK1vDggYcxepOwmHDj0xA==
X-Received: by 2002:a05:6a00:24d5:b0:50d:eea9:507 with SMTP id d21-20020a056a0024d500b0050deea90507mr18917279pfv.15.1651750059681;
        Thu, 05 May 2022 04:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytfP5B51SFcFIISGupq0ATsP4FvhC4awHHvD/jUWRaIw6GUg7mBG5q+iT5RdJA8FOABsI+zQ==
X-Received: by 2002:a05:6a00:24d5:b0:50d:eea9:507 with SMTP id d21-20020a056a0024d500b0050deea90507mr18917265pfv.15.1651750059427;
        Thu, 05 May 2022 04:27:39 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t11-20020a170902d14b00b0015e8d4eb1fesm1273554plt.72.2022.05.05.04.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 04:27:38 -0700 (PDT)
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
References: <20220427191314.222867-1-jlayton@kernel.org>
 <20220427191314.222867-59-jlayton@kernel.org>
 <f2557ca6-adfc-c661-b2f8-9e17eff264e8@redhat.com>
 <77caeb6df50d890028ee5fd0d7cacc01595f1e18.camel@kernel.org>
 <e827b044-3a92-858e-141d-1ebb9e477935@redhat.com>
 <fa78d711f0974b09ff811510b67a52bb9ba5eaf6.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <a9d26503-210e-ef0d-d50d-7f305aebd02e@redhat.com>
Date:   Thu, 5 May 2022 19:27:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <fa78d711f0974b09ff811510b67a52bb9ba5eaf6.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/5/22 7:12 PM, Jeff Layton wrote:
> On Thu, 2022-05-05 at 19:05 +0800, Xiubo Li wrote:
>> On 5/5/22 6:53 PM, Jeff Layton wrote:
>>> On Thu, 2022-05-05 at 17:34 +0800, Xiubo Li wrote:
>>>> On 4/28/22 3:13 AM, Jeff Layton wrote:
>>>>> Allow writepage to issue encrypted writes. Extend out the requested size
>>>>> and offset to cover complete blocks, and then encrypt and write them to
>>>>> the OSDs.
>>>>>
>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>>> ---
>>>>>     fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>>>>>     1 file changed, 27 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>>> index d65d431ec933..f54940fc96ee 100644
>>>>> --- a/fs/ceph/addr.c
>>>>> +++ b/fs/ceph/addr.c
>>>>> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>>     	loff_t page_off = page_offset(page);
>>>>>     	int err;
>>>>>     	loff_t len = thp_size(page);
>>>>> +	loff_t wlen;
>>>>>     	struct ceph_writeback_ctl ceph_wbc;
>>>>>     	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>>>>     	struct ceph_osd_request *req;
>>>>>     	bool caching = ceph_is_cache_enabled(inode);
>>>>> +	struct page *bounce_page = NULL;
>>>>>     
>>>>>     	dout("writepage %p idx %lu\n", page, page->index);
>>>>>     
>>>>> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>>     
>>>>>     	if (ceph_wbc.i_size < page_off + len)
>>>>>     		len = ceph_wbc.i_size - page_off;
>>>>> +	if (IS_ENCRYPTED(inode))
>>>>> +		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
>>>>>     
>>>>>     	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
>>>>>     	     inode, page, page->index, page_off, len, snapc, snapc->seq);
>>>>> @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>>     	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>>>>>     		fsc->write_congested = true;
>>>>>     
>>>>> -	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
>>>>> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
>>>>> -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
>>>>> -				    true);
>>>>> +	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
>>>>> +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
>>>>> +				    CEPH_OSD_FLAG_WRITE, snapc,
>>>>> +				    ceph_wbc.truncate_seq,
>>>>> +				    ceph_wbc.truncate_size, true);
>>>>>     	if (IS_ERR(req)) {
>>>>>     		redirty_page_for_writepage(wbc, page);
>>>>>     		return PTR_ERR(req);
>>>>>     	}
>>>>>     
>>>>> +	if (wlen < len)
>>>>> +		len = wlen;
>>>>> +
>>>>>     	set_page_writeback(page);
>>>>>     	if (caching)
>>>>>     		ceph_set_page_fscache(page);
>>>>>     	ceph_fscache_write_to_cache(inode, page_off, len, caching);
>>>>>     
>>>>> +	if (IS_ENCRYPTED(inode)) {
>>>>> +		bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
>>>>> +								0, GFP_NOFS);
>>>>> +		if (IS_ERR(bounce_page)) {
>>>>> +			err = PTR_ERR(bounce_page);
>>>>> +			goto out;
>>>>> +		}
>>>>> +	}
>>>> Here IMO we should redirty the page instead of detaching the page's
>>>> private data in 'out:' ?
>>>>
>>>> -- Xiubo
>>>>
>>>>
>>> Good catch. I think you're right. I'll fold the following delta into
>>> this patch:
>>>
>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> index f54940fc96ee..b266656f2951 100644
>>> --- a/fs/ceph/addr.c
>>> +++ b/fs/ceph/addr.c
>>> @@ -655,10 +655,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>                   bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
>>>                                                                   0, GFP_NOFS);
>>>                   if (IS_ERR(bounce_page)) {
>>> -                       err = PTR_ERR(bounce_page);
>>> -                       goto out;
>>> +                       redirty_page_for_writepage(wbc, page);
>>> +                       end_page_writeback(page);
>>> +                       return PTR_ERR(bounce_page);
>> You should also call ceph_osdc_put_request() too ?
>>
>> -- Xiubo
>>
> Definitely:
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index f54940fc96ee..4dfa2892f3f5 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -655,10 +655,13 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>                  bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
>                                                                  0, GFP_NOFS);
>                  if (IS_ERR(bounce_page)) {
> -                       err = PTR_ERR(bounce_page);
> -                       goto out;
> +                       redirty_page_for_writepage(wbc, page);
> +                       end_page_writeback(page);
> +                       ceph_osdc_put_request(req);
> +                       return PTR_ERR(bounce_page);
>                  }
>          }
> +
>          /* it may be a short write due to an object boundary */
>          WARN_ON_ONCE(len > thp_size(page));
>          osd_req_op_extent_osd_data_pages(req, 0,

Please remove the 'out' tag, it's not needed any more.

The others LGTM.

-- Xiubo


>
>>>                   }
>>>           }
>>> +
>>>           /* it may be a short write due to an object boundary */
>>>           WARN_ON_ONCE(len > thp_size(page));
>>>           osd_req_op_extent_osd_data_pages(req, 0,
>>>
>>>
>>>>>     	/* it may be a short write due to an object boundary */
>>>>>     	WARN_ON_ONCE(len > thp_size(page));
>>>>> -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
>>>>> -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
>>>>> +	osd_req_op_extent_osd_data_pages(req, 0,
>>>>> +			bounce_page ? &bounce_page : &page, wlen, 0,
>>>>> +			false, false);
>>>>> +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
>>>>> +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
>>>>>     
>>>>>     	req->r_mtime = inode->i_mtime;
>>>>>     	err = ceph_osdc_start_request(osdc, req, true);
>>>>> @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>>     
>>>>>     	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>>>>>     				  req->r_end_latency, len, err);
>>>>> -
>>>>> +	fscrypt_free_bounce_page(bounce_page);
>>>>> +out:
>>>>>     	ceph_osdc_put_request(req);
>>>>>     	if (err == 0)
>>>>>     		err = len;

