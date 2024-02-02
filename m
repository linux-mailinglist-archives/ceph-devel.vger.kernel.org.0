Return-Path: <ceph-devel+bounces-795-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C39846527
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Feb 2024 01:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F92A1F2611E
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Feb 2024 00:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF21D53A2;
	Fri,  2 Feb 2024 00:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/eKIMlg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065955380
	for <ceph-devel@vger.kernel.org>; Fri,  2 Feb 2024 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706835061; cv=none; b=lWDmnBNvan6dSwMQKnABw6qYqTSB7EMgQCzqeWRdyV4RZAsnTcU4yi7etr8WDaiue+UkTLwRnT9Qxo0wq6DdR1P7lHTKAAdw7MGH0vukhsTTW+8Q6GjYq/nyX1Kc39HqVUAEwK09Swdww3I5FpNxEX01SsTDtOzPyPOc6hpXZ44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706835061; c=relaxed/simple;
	bh=p6sKUrA74SEgTzaR42xGIxujFxoxubLDlpBXmOupfbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EFNB2NMsFqoz+9NNJOY7s6Zu1pQ1kcZLFnYYAwP3ItgdDKqhH+ROoj9NKklaBeEz6Z6uCv1KgZr/oHGPqXCwho47i77BH3/j4vL7gFZ/7yF/lUB8zeLyKyvtq1y/O3ZRGrkCOHdWvow915SSmHGX4cuv4eBuui03j7y9rR6FUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q/eKIMlg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706835057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oMG/1AaZVopcP4xQZV9L8SkfT4uKVO3uKKOBobAaE1w=;
	b=Q/eKIMlgzGvBoURL2PQX+eJOTrvtzMugg9oaRrSmc4aZFfdzebOoFjcTIyA8+SRj7+bsbi
	hAlh0K/7LlZLZgOLBk4OCtfVNRIz3fsZM4yMG3553Yrc5MKNFjT3i+gkyO6zSIo5kmnJad
	IE0zgn6LuFl3Re++4x9bJN+ExTKh87E=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-9UYS1K0VNNmj6dkQYP6tuw-1; Thu, 01 Feb 2024 19:50:56 -0500
X-MC-Unique: 9UYS1K0VNNmj6dkQYP6tuw-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2961c69e35dso950601a91.2
        for <ceph-devel@vger.kernel.org>; Thu, 01 Feb 2024 16:50:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706835055; x=1707439855;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMG/1AaZVopcP4xQZV9L8SkfT4uKVO3uKKOBobAaE1w=;
        b=uaxv5vV+CYXETLFSEvtt1nCujzn32Io6ksTE2+XOHaKCSkM1Y8UJ4fx0U1Qti5OppC
         YL5RfiH+36I9lRlp9bxNF1OgzE6rfTHfP9brEjNA+OeWnlC4LTf3tVu8cUBAEn7x0reY
         7kdVkKJYWksfNa8uvzkpj1RDyHv/OfZu32bESZFNEElQJyHRZBgaeg9flLtkTPX+CWUg
         sTYuY/q0U466Xns/Af4ckVus+D+T9xaC9fCLWNVFspOL/N3vVTCD4D3n2Kus5gFPq2ru
         HDAH2R0eF/jLCntwUPyjUAEph4NJBUvkajx4BvM3orrwxxWoZqSEScTR5e5UnMnJ6qjY
         tXmw==
X-Gm-Message-State: AOJu0YyW7n/ejAP/fiNim+ETPvYJuctO24dX4NHKk+U/tfmtRfLjD0FE
	pJu8bJK3p/rRB1bYj1uyIckzX0cvrzdIoI8yvjV+pJVX6jNLehJlEMTWLmSFyxqndOQXBtiAhmG
	GdWk2evG5ulvkwzG0nMv70t4TBdyl7dNRQ6k/iUAnJXEKwTtVRKDu8fVYrqc=
X-Received: by 2002:a17:90a:c285:b0:296:15ed:b220 with SMTP id f5-20020a17090ac28500b0029615edb220mr3465582pjt.45.1706835055557;
        Thu, 01 Feb 2024 16:50:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEtjwm/MoGz9bXx0WMI27smJF2AxdWKhpRbRxRaOG7UDDvPoV/V4mDYd0Tq3A6GxSSsFbgphg==
X-Received: by 2002:a17:90a:c285:b0:296:15ed:b220 with SMTP id f5-20020a17090ac28500b0029615edb220mr3465566pjt.45.1706835055228;
        Thu, 01 Feb 2024 16:50:55 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXWRtDQD0dJscw6vd0RkJYgu3f6D6lDdwjuCJAIzsNnWokhTuiyxAuhPymR8wPkQ5IiflEgUtuY6tCm+aNfkR66WMisnBc90TU8Nk9WV/m7iv5Ro6Kiomw3RtL1U2b49/X2VMTUq5GFUzDsvhmmegmXC7bZOWHF3XjC8qwL6HqNjWCcDp/KBsDEmSOC9dJL5weeviVabm1D9iI66ECBifVi
Received: from [10.72.112.116] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902e90500b001d7907eb711sm398066pld.182.2024.02.01.16.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 16:50:54 -0800 (PST)
Message-ID: <9bd975c2-50d3-40aa-bc96-7fc82bb051b5@redhat.com>
Date: Fri, 2 Feb 2024 08:50:49 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: increment refcount before usage
Content-Language: en-US
To: ridave@redhat.com, ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
 mchangir@redhat.com, rishabhddave@gmail.com
References: <20240201113716.27131-1-ridave@redhat.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240201113716.27131-1-ridave@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/1/24 19:37, ridave@redhat.com wrote:
> From: Rishabh Dave <ridave@redhat.com>
>
> In fs/ceph/caps.c, in "encode_cap_msg()", "use after free" error was
> caught by KASAN at this line - 'ceph_buffer_get(arg->xattr_buf);'. This
> implies before the refcount could be increment here, it was freed.
>
> In same file, in "handle_cap_grant()" refcount is decremented by this
> line - "ceph_buffer_put(ci->i_xattrs.blob);". It appears that a race
> occurred and resource was freed by the latter line before the former
> line
> could increment it.
>
> encode_cap_msg() is called by __send_cap() and __send_cap() is called by
> ceph_check_caps() after calling __prep_cap(). __prep_cap() is where
> "arg->xattr_buf" is assigned to "ci->i_xattrs.blob" . This is the spot
> where the refcount must be increased to prevent "use after free" error.
>
> URL: https://tracker.ceph.com/issues/59259
> Signed-off-by: Rishabh Dave <ridave@redhat.com>
> ---
>   fs/ceph/caps.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5501c86b337d..0ca7dce48172 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1452,7 +1452,7 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
>   	if (flushing & CEPH_CAP_XATTR_EXCL) {
>   		arg->old_xattr_buf = __ceph_build_xattrs_blob(ci);
>   		arg->xattr_version = ci->i_xattrs.version;
> -		arg->xattr_buf = ci->i_xattrs.blob;
> +		arg->xattr_buf = ceph_buffer_get(ci->i_xattrs.blob);
>   	} else {
>   		arg->xattr_buf = NULL;
>   		arg->old_xattr_buf = NULL;
> @@ -1553,6 +1553,7 @@ static void __send_cap(struct cap_msg_args *arg, struct ceph_inode_info *ci)
>   	encode_cap_msg(msg, arg);
>   	ceph_con_send(&arg->session->s_con, msg);
>   	ceph_buffer_put(arg->old_xattr_buf);
> +	ceph_buffer_put(arg->xattr_buf);
>   	if (arg->wake)
>   		wake_up_all(&ci->i_cap_wq);
>   }

Applied to the ceph-client's 'testing' branch and will run the tests.

Thanks

- Xiubo


