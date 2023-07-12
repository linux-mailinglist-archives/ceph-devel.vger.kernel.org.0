Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06089750865
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jul 2023 14:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjGLMew (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jul 2023 08:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjGLMeu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jul 2023 08:34:50 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9255410EF
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:34:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-c5ffb6cda23so7704585276.0
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1689165288; x=1691757288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vRpgYmFZu12Ve3gzG113Iq+Q4hA5NKe9jOG9Ea/1lC0=;
        b=RZBkrsOGgNXaPSoSumfB5BrYAWUe6T/yz6kM+mFze6aNUdkYy5DvlgLWnU+Ov5FUZ3
         qkX43lAis+kphCY3qonViMAfz92TThC5WxsfOoV9y52k1HPBptnrFduK8649GtF7usi3
         wybc7V3rkySCHBDryGRF0OrsVzrOijKxJU0ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689165288; x=1691757288;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vRpgYmFZu12Ve3gzG113Iq+Q4hA5NKe9jOG9Ea/1lC0=;
        b=RHVv6yinL8awTeHGN+M2JLIawxb9MwlY0jrwGePp5eqStBcEY85VOt7PUgHsKVmiiw
         KN4+mvpj5orgE1tR8/RD8vb2g2cxAoAx0lES8d0P9G+INCtKy0NO9XQY1oFfqPS6YxW1
         EPi26Q1jmbs/cSyDDwC/uZqg+MuR6Qwd4/g03gJHAWFkxmhj4ePqGBpO1tNxswwQH3So
         c2UafXrSz2B6ntzZAFVkzhvoiy6AjpL/+F5eco1T/tTkw7ViklRU48Va0cUBhOTKihH0
         eL+VxAB1e7STQqOoqfZ44WZ72MvXf2nJIR4ZD3u4ku4T2BV6SzTk2bg3SkfE+dqyWSE4
         cWlA==
X-Gm-Message-State: ABy/qLbHrtpwIMQN1x629UizfFVQ++YMvg9NfCXR7cS0fN/JeVLzqRF1
        UAVzzUCBvEr4kNeJP+Co3SPiB+k8jOKLrsK5gsA=
X-Google-Smtp-Source: APBJJlFIAhShJ8UxNUSXHW7+I+4zPBu6GtnDoN7fv3Z57C6YTyq6QbxW45ZmV5rx+HU8TYag8dYsxw==
X-Received: by 2002:a25:2603:0:b0:c6a:55e7:5b3f with SMTP id m3-20020a252603000000b00c6a55e75b3fmr14476056ybm.52.1689165287714;
        Wed, 12 Jul 2023 05:34:47 -0700 (PDT)
Received: from [10.211.55.3] (c-98-61-227-136.hsd1.mn.comcast.net. [98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id g4-20020a05690203c400b00bc7c81c3cecsm884080ybs.14.2023.07.12.05.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 05:34:47 -0700 (PDT)
Message-ID: <0f75ee65-67c6-4d65-a41b-1cd3944f4bc2@ieee.org>
Date:   Wed, 12 Jul 2023 07:34:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] libceph: harden msgr2.1 frame segment length checks
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Thelford Williams <thelford@google.com>
References: <20230712120718.28904-1-idryomov@gmail.com>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20230712120718.28904-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 7/12/23 7:07 AM, Ilya Dryomov wrote:
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

Doesn't the ctrl_len ultimately come from the outside?  If so
you should not do BUG_ON() with bad values.

Could you have this function return 0 for a bad value instead?
It means you need to handle it in the callers, but better than
than killing the machine.

					-Alex


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

