Return-Path: <ceph-devel+bounces-111-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8333E7EEBE9
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 06:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38AAA1F22762
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Nov 2023 05:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628BF8F68;
	Fri, 17 Nov 2023 05:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQUXrMoE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0F0D52
	for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 21:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700198417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1LgR+1cpINHMU5YnbgiAgsP+TUg2NFdn1atrpXyM33I=;
	b=SQUXrMoExQ3KqFAjhoGBJ/9o27suMEMlYFWTewjTxeKtlKeKn6awI/wN6PMBiBiIwd+dQO
	xP4LuYpFNIZYSkgdiB+ZNZvdCfjhY59HyxLHGfFMgbElbcukqtBupXY8wpsJ4BiTOlu2FG
	JbafqNQnW5H9mSFe4hwrHZM8CINtvkI=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-iZvEkzkgMfSuXXJnEA95VQ-1; Fri, 17 Nov 2023 00:20:13 -0500
X-MC-Unique: iZvEkzkgMfSuXXJnEA95VQ-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5c87663a873so1357577b3.2
        for <ceph-devel@vger.kernel.org>; Thu, 16 Nov 2023 21:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700198412; x=1700803212;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1LgR+1cpINHMU5YnbgiAgsP+TUg2NFdn1atrpXyM33I=;
        b=G57/FWaLG2EDKuMjfPppn1En6+gGuUmoB4AcTvKXK+A3ZatNPmui+rNkmK1tRHWDNk
         uBtg7BHLIFaazDClA9Pg7E56EIkAZBH0iIIzy21WqB8572B8CkZAmosheDAQe7J8iirs
         w1ZRwOMSRJcNbT7AIoOE9X9mphZ0j74dGeJXfR2CiDTVoI1S4wOfJRt951Opf76yyf8Q
         /vDXgsot+Ni+6IjsxGkHVC40IzUwlnlVr2cObzxIHKBbd00qPROB7MZGyHBPyO6IdUlK
         T58SK/dz4Du0qMs4L0p4559mpZVvG3H5c1HpAs3ycWFZ+UzwRZiogepDJbVx7yVM49PV
         fPgQ==
X-Gm-Message-State: AOJu0Yy9qVOD84b6U4J1dKDmLkormWaEEUDDRBDSpctXH+DGOyfXvpQm
	282wYvr/i8UYjvtH6vxtcPJNKkmo9Oiar4DpXNeDzBjVP42G0ODvJVA2E/PvkLNrXLOL6Q3+cWm
	f4jlw75ue2MSGRc+Vaa+dEA==
X-Received: by 2002:a81:7189:0:b0:5a7:c8f3:de4b with SMTP id m131-20020a817189000000b005a7c8f3de4bmr18598116ywc.8.1700198412152;
        Thu, 16 Nov 2023 21:20:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHlcZR7k6zOOCIPc4berrh6szs/JyiHPzFXnrY1X85pv3TcZ1b9h6YwlKaJN5rKt8bt5X81Q==
X-Received: by 2002:a81:7189:0:b0:5a7:c8f3:de4b with SMTP id m131-20020a817189000000b005a7c8f3de4bmr18598101ywc.8.1700198411887;
        Thu, 16 Nov 2023 21:20:11 -0800 (PST)
Received: from [10.72.112.63] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id fj36-20020a056a003a2400b006c4d1bb81d6sm618246pfb.67.2023.11.16.21.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 21:20:11 -0800 (PST)
Message-ID: <539fee36-cbd2-bb9b-b983-130a60bd0171@redhat.com>
Date: Fri, 17 Nov 2023 13:20:06 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: fix deadlock or deadcode of misusing dget()
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
References: <20231117031951.710177-1-xiubli@redhat.com>
 <20231117044546.GC1957730@ZenIV>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231117044546.GC1957730@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/17/23 12:45, Al Viro wrote:
> On Fri, Nov 17, 2023 at 11:19:51AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The lock order is incorrect between denty and its parent, we should
>> always make sure that the parent get the lock first.
>>
>> Switch to use the 'dget_parent()' to get the parent dentry and also
>> keep holding the parent until the corresponding inode is not being
>> refereenced.
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Al Viro <viro@zeniv.linux.org.uk>
>> URL: https://www.spinics.net/lists/ceph-devel/msg58622.html
>> Fixes: adf0d68701c7 ("ceph: fix unsafe dcache access in ceph_encode_dentry_release")
>> Cc: Jeff Layton <jlayton@kernel.org>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> +	if (!dir) {
>> +		parent = dget_parent(dentry);
>> +		dir = d_inode(parent);
>> +	}
> It's never actually called with dir == NULL.  Not since 2016.
>
> All you need is this, _maybe_ with BUG_ON(!dir); added in the beginning of the function.
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 2c0b8dc3dd0d..22d6ea97938f 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4887,7 +4887,6 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
>   			       struct inode *dir,
>   			       int mds, int drop, int unless)
>   {
> -	struct dentry *parent = NULL;
>   	struct ceph_mds_request_release *rel = *p;
>   	struct ceph_dentry_info *di = ceph_dentry(dentry);
>   	struct ceph_client *cl;
> @@ -4903,14 +4902,9 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
>   	spin_lock(&dentry->d_lock);
>   	if (di->lease_session && di->lease_session->s_mds == mds)
>   		force = 1;
> -	if (!dir) {
> -		parent = dget(dentry->d_parent);
> -		dir = d_inode(parent);
> -	}
>   	spin_unlock(&dentry->d_lock);
>   
>   	ret = ceph_encode_inode_release(p, dir, mds, drop, unless, force);
> -	dput(parent);
>   
>   	cl = ceph_inode_to_client(dir);
>   	spin_lock(&dentry->d_lock);

Yeah, you are right.

Will update it.

Thanks

- Xiubo



