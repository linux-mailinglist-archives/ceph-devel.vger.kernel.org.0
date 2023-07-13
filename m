Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0015751E85
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jul 2023 12:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjGMKLZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jul 2023 06:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjGMKLR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jul 2023 06:11:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856572D7F
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jul 2023 03:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689242961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bbYBk0/rm4RGGepS4311ZyX9Js4o8XcciMo1V38iWk=;
        b=GsJ2rE8QfeeTNEo5RPwv/Xx51VwY9MaMfAuf7qlXZdX+55v0Mvp4HZQD1M1JP5dNWrS9/l
        L3yEv/fZMZEX6dIgnKAG1o+PE+TsMgHLljXD7OvP431f5B5RColYWuvdtwpjLkjjqSUw2e
        etQOiBbJjEwNSyU7tkVcwM4BWVvPVO0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-dISfHu1hOUej_Vk9dmmH2w-1; Thu, 13 Jul 2023 06:09:20 -0400
X-MC-Unique: dISfHu1hOUej_Vk9dmmH2w-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-66eba523cd9so250621b3a.2
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jul 2023 03:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689242959; x=1691834959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3bbYBk0/rm4RGGepS4311ZyX9Js4o8XcciMo1V38iWk=;
        b=VX+umzMUDUgebsTcGkB8c1oeHSMNuCCcp5fJVObaZEdbV5uNF8VxGz42vESzYoLmtF
         vtwKi4S8Am6eo3vkUk97tndGS2McrnbgETFFhbh+ua8YafK9PoloGATs9NknixTMlQqs
         G9LNtbB+XyjFyK4w4YqXbCbzZlFERYKyN0yxgCO7QJTZCLlOVeln1t1Z0OhOc27PEumz
         sQ1dcEu2yBStWQp8vT2y4+Fcf1KmFfAMEdXV1jyqkijRxCg04ZAii2rOTReXIncLKh5R
         OZVt5r2g28JAPw3l1smOdIS52qRevEGn1bDQfHkt4Hfgwuj5+MfFRIzwXOUoxcOHxsmf
         shmA==
X-Gm-Message-State: ABy/qLYFNxMyQNDAjxjqbeIuPVSgvEOeRWLUuLbFuRKrA+6tUyqyQb9Q
        U+Ml8o2IAICBTi98rzb4s+QTYutA3AZ1kVHXJ8Wr7MMCI8yXVKZMKLg8aQ8hRAYmLO87RhPjJIB
        zHqG+ay5S0rBjNVBiTdUHdw==
X-Received: by 2002:a05:6a00:139d:b0:673:8dfb:af32 with SMTP id t29-20020a056a00139d00b006738dfbaf32mr715278pfg.26.1689242959161;
        Thu, 13 Jul 2023 03:09:19 -0700 (PDT)
X-Google-Smtp-Source: APBJJlE+OXXOz+BtTaO+SpFRnkdtm27Y/sEehqvPkLpE6y+GxAVBCG/UOfDcHd1yl4FQLXViaMDymA==
X-Received: by 2002:a05:6a00:139d:b0:673:8dfb:af32 with SMTP id t29-20020a056a00139d00b006738dfbaf32mr715266pfg.26.1689242958886;
        Thu, 13 Jul 2023 03:09:18 -0700 (PDT)
Received: from [10.72.12.161] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e9-20020aa78c49000000b00666e2dac482sm5075528pfd.124.2023.07.13.03.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 03:09:18 -0700 (PDT)
Message-ID: <9e5a8941-0b29-c018-babf-a45742bea03f@redhat.com>
Date:   Thu, 13 Jul 2023 18:09:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] libceph: harden msgr2.1 frame segment length checks
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Thelford Williams <thelford@google.com>
References: <20230712120718.28904-1-idryomov@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230712120718.28904-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/12/23 20:07, Ilya Dryomov wrote:
> ceph_frame_desc::fd_lens is an int array.  decode_preamble() thus
> effectively casts u32 -> int but the checks for segment lengths are
> written as if on unsigned values.  While reading in HELLO or one of the
> AUTH frames (before authentication is completed), arithmetic in
> head_onwire_len() can get duped by negative ctrl_len and produce
> head_len which is less than CEPH_PREAMBLE_LEN but still positive.
> This would lead to a buffer overrun in prepare_read_control() as the
> preamble gets copied to the newly allocated buffer of size head_len.
>
> Cc: stable@vger.kernel.org
> Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
> Reported-by: Thelford Williams <thelford@google.com>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   net/ceph/messenger_v2.c | 41 ++++++++++++++++++++++++++---------------
>   1 file changed, 26 insertions(+), 15 deletions(-)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 1a888b86a494..1df1d29dee92 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -390,6 +390,8 @@ static int head_onwire_len(int ctrl_len, bool secure)
>   	int head_len;
>   	int rem_len;
>   
> +	BUG_ON(ctrl_len < 0 || ctrl_len > CEPH_MSG_MAX_CONTROL_LEN);
> +
>   	if (secure) {
>   		head_len = CEPH_PREAMBLE_SECURE_LEN;
>   		if (ctrl_len > CEPH_PREAMBLE_INLINE_LEN) {
> @@ -408,6 +410,10 @@ static int head_onwire_len(int ctrl_len, bool secure)
>   static int __tail_onwire_len(int front_len, int middle_len, int data_len,
>   			     bool secure)
>   {
> +	BUG_ON(front_len < 0 || front_len > CEPH_MSG_MAX_FRONT_LEN ||
> +	       middle_len < 0 || middle_len > CEPH_MSG_MAX_MIDDLE_LEN ||
> +	       data_len < 0 || data_len > CEPH_MSG_MAX_DATA_LEN);
> +
>   	if (!front_len && !middle_len && !data_len)
>   		return 0;
>   
> @@ -520,29 +526,34 @@ static int decode_preamble(void *p, struct ceph_frame_desc *desc)
>   		desc->fd_aligns[i] = ceph_decode_16(&p);
>   	}
>   
> -	/*
> -	 * This would fire for FRAME_TAG_WAIT (it has one empty
> -	 * segment), but we should never get it as client.
> -	 */
> -	if (!desc->fd_lens[desc->fd_seg_cnt - 1]) {
> -		pr_err("last segment empty\n");
> +	if (desc->fd_lens[0] < 0 ||
> +	    desc->fd_lens[0] > CEPH_MSG_MAX_CONTROL_LEN) {
> +		pr_err("bad control segment length %d\n", desc->fd_lens[0]);
>   		return -EINVAL;
>   	}
> -
> -	if (desc->fd_lens[0] > CEPH_MSG_MAX_CONTROL_LEN) {
> -		pr_err("control segment too big %d\n", desc->fd_lens[0]);
> +	if (desc->fd_lens[1] < 0 ||
> +	    desc->fd_lens[1] > CEPH_MSG_MAX_FRONT_LEN) {
> +		pr_err("bad front segment length %d\n", desc->fd_lens[1]);
>   		return -EINVAL;
>   	}
> -	if (desc->fd_lens[1] > CEPH_MSG_MAX_FRONT_LEN) {
> -		pr_err("front segment too big %d\n", desc->fd_lens[1]);
> +	if (desc->fd_lens[2] < 0 ||
> +	    desc->fd_lens[2] > CEPH_MSG_MAX_MIDDLE_LEN) {
> +		pr_err("bad middle segment length %d\n", desc->fd_lens[2]);
>   		return -EINVAL;
>   	}
> -	if (desc->fd_lens[2] > CEPH_MSG_MAX_MIDDLE_LEN) {
> -		pr_err("middle segment too big %d\n", desc->fd_lens[2]);
> +	if (desc->fd_lens[3] < 0 ||
> +	    desc->fd_lens[3] > CEPH_MSG_MAX_DATA_LEN) {
> +		pr_err("bad data segment length %d\n", desc->fd_lens[3]);
>   		return -EINVAL;
>   	}
> -	if (desc->fd_lens[3] > CEPH_MSG_MAX_DATA_LEN) {
> -		pr_err("data segment too big %d\n", desc->fd_lens[3]);
> +
> +	/*
> +	 * This would fire for FRAME_TAG_WAIT (it has one empty
> +	 * segment), but we should never get it as client.
> +	 */
> +	if (!desc->fd_lens[desc->fd_seg_cnt - 1]) {
> +		pr_err("last segment empty, segment count %d\n",
> +		       desc->fd_seg_cnt);
>   		return -EINVAL;
>   	}
>   

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


