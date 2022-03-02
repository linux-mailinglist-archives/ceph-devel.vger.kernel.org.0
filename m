Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609F44CA94A
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbiCBPmB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 10:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiCBPmB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 10:42:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD47CB640
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:41:17 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q8so2316210iod.2
        for <ceph-devel@vger.kernel.org>; Wed, 02 Mar 2022 07:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4F3aemPFDej+wbO6DzqdopFuHWzJRbqudp3FsgF+CCQ=;
        b=bV75EIJTGAI/8GJLE1xjlEm5dRi/H0XPxzQPJ2/5rmOBjHG2D3ebSO6yP4rL5nOGhV
         aLXH7RQHJ4mALaNdRaSH2R3v5PjCS6HaZWzxwZgP8zV81+dNaQAz9l6r9sIBE6P37mKI
         FBVkrV2NExXTKJllfa2ZDmIOhFPKvzkXbW+b8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4F3aemPFDej+wbO6DzqdopFuHWzJRbqudp3FsgF+CCQ=;
        b=md0PexfYWz+WbUpb0z/TUfg02G69xj/csLokvbAMZqR3n2dAy6Muh9dAePNw1Dfkp5
         7iWrUcgoC2+GwhSfKpCSdVa1SMSaQ28hgW7BeW/+3h+sBd+ogCecnJrLXq7TgogDCyoq
         EYoRZ7vO4zWTTSad+imGaQhl/Pda4Z7LWfh8HrtTkdhPMOSIDQH3BiYotU2Po0aVPadH
         Y/XoXJP9HSKDyjglbZ/WcvWIRErETbbN2klSoliWDVN7Ls1+Flv+LYn9nUvK9uV0P6RM
         Q4H36LKgoeE7TFEcKciZaAio14aAyn4twEKpOEAB80yo+1lghYQB61c6IA/QqlkfbIDI
         IXug==
X-Gm-Message-State: AOAM5311wyqeDz9LsvRTyLWgDQcA8exgmJurRz2GI9yHl/eSAAlxYzoK
        zPPquKVoBZ6uqNN9Et83Wbcs4Q==
X-Google-Smtp-Source: ABdhPJx8pOPWFm8Mvchc0e0xIOmXD5vNeNv0kBU7qOpTAQ+lk7Jb1p7qwNggxU71jwg0kO2BozdYvQ==
X-Received: by 2002:a05:6638:381b:b0:314:8258:39d4 with SMTP id i27-20020a056638381b00b00314825839d4mr25434732jav.172.1646235677264;
        Wed, 02 Mar 2022 07:41:17 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s12-20020a92cbcc000000b002bd04428740sm9663676ilq.80.2022.03.02.07.41.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 07:41:16 -0800 (PST)
Message-ID: <b10682fe-54a9-5103-4921-66f8c0f22382@ieee.org>
Date:   Wed, 2 Mar 2022 09:41:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] libceph: fix last_piece calculation in
 ceph_msg_data_pages_advance
Content-Language: en-US
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
References: <20220302153744.43541-1-jlayton@kernel.org>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20220302153744.43541-1-jlayton@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/2/22 9:37 AM, Jeff Layton wrote:
> It's possible we'll have less than a page's worth of residual data, that
> is stradding the last two pages in the array. That will make it
> incorrectly set the last_piece boolean when it shouldn't.
> 
> Account for a non-zero cursor->page_offset when advancing.

It's been quite a while I looked at this code, but isn't
cursor->resid supposed to be the number of bytes remaining,
irrespective of the offset?

Have you found this to cause a failure?

					-Alex

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   net/ceph/messenger.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index d3bb656308b4..3f8453773cc8 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -894,10 +894,9 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
>   		return false;   /* no more data */
>   
>   	/* Move on to the next page; offset is already at 0 */
> -
>   	BUG_ON(cursor->page_index >= cursor->page_count);
>   	cursor->page_index++;
> -	cursor->last_piece = cursor->resid <= PAGE_SIZE;
> +	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
>   
>   	return true;
>   }

