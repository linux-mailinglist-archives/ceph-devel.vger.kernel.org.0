Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664FF53CA2D
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jun 2022 14:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244417AbiFCMsa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Jun 2022 08:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbiFCMs3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Jun 2022 08:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AA1D1263F
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 05:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654260507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XN6dOpxuJg+GxeTMZ23WNhXFrjNiEoeLdLINI1z48H8=;
        b=F8jgw2srQSB3HJEHxQuoLWyKvceuKeuwhRZ8s4EiFK6uyndHvPB8dQ6C+Wm4gCy/cCE1C3
        4MM/4WCfDdCjA1l2aYR6ZRS6YHZGJ+e5m+7RM65AnItqH8zeSX3y0i/FxZS8Ewcjxm2Tbx
        YK49SjimAaw1DFlxpN1OgnHz9QGQhDI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-uIsSTxGZNb6xGi0gNp-nTg-1; Fri, 03 Jun 2022 08:48:27 -0400
X-MC-Unique: uIsSTxGZNb6xGi0gNp-nTg-1
Received: by mail-pj1-f71.google.com with SMTP id il9-20020a17090b164900b001e31dd8be25so7243354pjb.3
        for <ceph-devel@vger.kernel.org>; Fri, 03 Jun 2022 05:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=XN6dOpxuJg+GxeTMZ23WNhXFrjNiEoeLdLINI1z48H8=;
        b=lw96LyvYgw2fTLHxbktVu3pXoecyiIqcLLEgd0axLax+zFFLLB3HjpTA/38HLu7vzY
         IEk8busCI76gpo+FuayIluWqf4Pddwz6XFbvBgM5oTeBPpW3YYvQIRKRFNP1MeYTbEOP
         EzJVb0IjPrWaplksAKIBIK6oBRPldgQUt+igod2hbLTFnPy+37NchJ/yIFqCKSrM/Sfd
         RzLbTfoeyocGV/iOUa7oM+UDXlwKC1mnW1Ycsu1JCKmyNGz68py9A/Qff94ZxJWErYR8
         k9KEvFGUhAeHA+RBqHAjZD+QomFyItZgwS6o4b7Gq/Yplwyhf2tZ+BQL7bnxlQNW94T3
         S0lA==
X-Gm-Message-State: AOAM533FmKCC+Au0R9YptS9hMeUGKzLs0QWWVMDvuyS7NAAI0g+yZz2j
        5WvGrMdt0aIN6Uk+PjLVLq4Pmh+1EKQXd/WRQQoqaqFRa+Ty5wQ+3nDsGe+a8QyhARbnzK9CdHK
        F9Fd4xsaDQcdA9WqlD1ficQ==
X-Received: by 2002:a63:87c8:0:b0:3fd:41a7:bcc with SMTP id i191-20020a6387c8000000b003fd41a70bccmr476272pge.543.1654260505673;
        Fri, 03 Jun 2022 05:48:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzX2t/cynUTdJbcEXOu3i+MXvjrfqKAk5lDkdHjqwj/jSQDEKGsMTC6xVy/eeBy2cEwdpBp7A==
X-Received: by 2002:a63:87c8:0:b0:3fd:41a7:bcc with SMTP id i191-20020a6387c8000000b003fd41a70bccmr476250pge.543.1654260505423;
        Fri, 03 Jun 2022 05:48:25 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902a3cb00b0015f0dcd1579sm5388446plb.9.2022.06.03.05.48.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jun 2022 05:48:24 -0700 (PDT)
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
To:     Jeff Layton <jlayton@kernel.org>,
        =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
References: <20220427191314.222867-1-jlayton@kernel.org>
 <20220427191314.222867-59-jlayton@kernel.org>
 <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
 <875yli3y34.fsf@brahms.olymp>
 <d18e02c9d6652e533f8a81c92ab011d907b5f8fe.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dca97502-6afc-389c-86b7-f9d302e4d120@redhat.com>
Date:   Fri, 3 Jun 2022 20:48:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d18e02c9d6652e533f8a81c92ab011d907b5f8fe.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/3/22 8:24 PM, Jeff Layton wrote:
> On Fri, 2022-06-03 at 10:17 +0100, Luís Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>>
>>> On Wed, 2022-04-27 at 15:13 -0400, Jeff Layton wrote:
>>>> Allow writepage to issue encrypted writes. Extend out the requested size
>>>> and offset to cover complete blocks, and then encrypt and write them to
>>>> the OSDs.
>>>>
>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
>>>> ---
>>>>   fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>>>>   1 file changed, 27 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>> index d65d431ec933..f54940fc96ee 100644
>>>> --- a/fs/ceph/addr.c
>>>> +++ b/fs/ceph/addr.c
>>>> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>   	loff_t page_off = page_offset(page);
>>>>   	int err;
>>>>   	loff_t len = thp_size(page);
>>>> +	loff_t wlen;
>>>>   	struct ceph_writeback_ctl ceph_wbc;
>>>>   	struct ceph_osd_client *osdc = &fsc->client->osdc;
>>>>   	struct ceph_osd_request *req;
>>>>   	bool caching = ceph_is_cache_enabled(inode);
>>>> +	struct page *bounce_page = NULL;
>>>>   
>>>>   	dout("writepage %p idx %lu\n", page, page->index);
>>>>   
>>>> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>>>>   
>>>>   	if (ceph_wbc.i_size < page_off + len)
>>>>   		len = ceph_wbc.i_size - page_off;
>>>> +	if (IS_ENCRYPTED(inode))
>>>> +		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
>>>>   
>>> The above is buggy. We're only setting "wlen" in the encrypted case. You
>>> would think that the compiler would catch that, but next usage of wlen
>>> just passes a pointer to it to another function and that cloaks the
>>> warning.
>> Yikes!  That's indeed the sort of things we got used to have compilers
>> complaining about.  That must have been fun to figure this out.  Nice ;-)
>>
> Yeah. I remember that some older versions of gcc would complain about
> uninitialized vars when you passed a pointer to it to another function.
> That went away a while back, which was good since it often fired on
> false positives.
>
> What would have been nice here would be for the compiler to notice that
> wlen was inconsistently initialized before we passed the pointer to the
> function. Not sure how hard that would be to catch though.

I didn't compile this branch with the FSCRYPT being disabled yet 
recently, not sure whether will the compiler complains it then.



