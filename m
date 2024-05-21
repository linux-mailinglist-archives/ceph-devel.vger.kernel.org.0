Return-Path: <ceph-devel+bounces-1153-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 525F48CA562
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 02:33:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47AC0B21B46
	for <lists+ceph-devel@lfdr.de>; Tue, 21 May 2024 00:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73AFF610C;
	Tue, 21 May 2024 00:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTJjHaxp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9615B7
	for <ceph-devel@vger.kernel.org>; Tue, 21 May 2024 00:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716251575; cv=none; b=j8wiNDtaFbkl5eEyOgU1PhchaGL9uaoIEG1glpI+Z0peRS3iTh1FMu8vqnFbGPI6Pp3Zpr2tSTdQvnCTymy1KaUYHSykGU5Y5jGEnckNrw2vRiG7WXP9Ek4+BTUJv1EHPBBRoZnKVO3vAy3xVcFPWH490M735s+fD4fHXFpELF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716251575; c=relaxed/simple;
	bh=fJOiTk/iNpIQGDBT8ov2FCIPhgk6zXZQNw1RaFJJ0Rk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4P9mhIoA9W+sIAWhSl0ajRFWg5BxhiH2zDVhqO1c3oc0R2cotQ306dCirMjTeWHYt3+FrDUdn9JcFP43tRtR+e8oJ+46w6JxJTPCHKK3oRwRWcIRBmB7dwioBopI70E4vMhwnC4+3Al/VurrXD20Lw8c2jYQbneThKAWlpM5FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTJjHaxp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716251572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wcLWECU84oFD1HOiYc28B9aeY6hAeWxqTdSGNd9MPRM=;
	b=KTJjHaxpFbPcQqOZYhEEY4HQu41jEjBQYn8v2tTNw3YvjtaoT4xWfbOq0ZbuxI5/VvaX0m
	wkTISLfdgRXSF8fSvURpr89UuMVHN8SuRec/DqReCATF139c8hzwpEHayDp/QBa+kMASg7
	1tKVvadZqpdHOW86drWAf3DXV0+T18Y=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-07vj44ZhMduVJWBaSrDUzA-1; Mon, 20 May 2024 20:32:50 -0400
X-MC-Unique: 07vj44ZhMduVJWBaSrDUzA-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5b2bc2bd85dso10155603eaf.2
        for <ceph-devel@vger.kernel.org>; Mon, 20 May 2024 17:32:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716251570; x=1716856370;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcLWECU84oFD1HOiYc28B9aeY6hAeWxqTdSGNd9MPRM=;
        b=tnHqSZZonW3G0CbDYj4yQqBRUQrOvD8P67HroEr3p69rbjmi7WnGDGbYf/+3T+UPvs
         SR+NRj9pe1B18ikFL9kBNrZcChb5Bv/4trGebpZyQeX4W+JabHR3bSl8oTnPuEPFCgDf
         hcqyidf0r+H+3ziJOGN1mI655FZTuxketsfBp0LGjsgS/tIsZlUsx7LwB73t315gAEy6
         rwrbKpJ6hrXCVTSREKeK8wbdL5ZVAnwx3fh84cfK0pZGJTfKtXl3RLLfYez8ir1+S172
         QgVHTfxjBZlVH8RklkYy01Yj4Pdi1W7Zw2tuGqn8FjZbP9MmYGENxVmBNTL5/nRLAHAB
         IJng==
X-Forwarded-Encrypted: i=1; AJvYcCUPuFPOfOYoWhKnOzxx5b7cR7e130F8CkdVrMwJFhPHNWflfESL2t9z/8kY1np7Yg80Y5DrY2ppW3UHdhQ4ScUl+CLSt/pvCm1k4w==
X-Gm-Message-State: AOJu0Yx9LhfKR3q41r2OH+5lIJTntfljWKzbcCvdQ8NHS6jkMHy0S50P
	E8SgOpr1aVz2wNUO0MDyK9pOrD7Qo5vqGZ+1F2h0Z6JFHFCuoUV77+sSKwV7VHqymN1uLxYzujr
	SleTY2rNC6SB/E79CsCz8z08x6rVHxqdJwTJlM9y7U+dq40vyeY6Mqf0VbKw=
X-Received: by 2002:a05:6358:8005:b0:192:75c4:2ee2 with SMTP id e5c5f4694b2df-193bb2dd2d1mr3145968855d.32.1716251569744;
        Mon, 20 May 2024 17:32:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETh+Vbu1JPihq8Oq65XxoXIbGLDFNVTlK2XPdjV3Px478h9iyYRKBexSoEeQC/zYwFYuhl2Q==
X-Received: by 2002:a05:6358:8005:b0:192:75c4:2ee2 with SMTP id e5c5f4694b2df-193bb2dd2d1mr3145966855d.32.1716251569220;
        Mon, 20 May 2024 17:32:49 -0700 (PDT)
Received: from [10.72.116.32] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-660ab682716sm5855077a12.88.2024.05.20.17.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 May 2024 17:32:48 -0700 (PDT)
Message-ID: <5561ff7d-16b3-40e1-b9c4-7327a0dabc05@redhat.com>
Date: Tue, 21 May 2024 08:32:43 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] doc: ceph: update userspace command to get CephFS
 metadata
To: Artem Ikonnikov <artem@datacrunch.io>, linux-doc@vger.kernel.org
Cc: Ilya Dryomov <idryomov@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 ceph-devel@vger.kernel.org
References: <ZkkgZlRk+PbFBUOJ@kurwa>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ZkkgZlRk+PbFBUOJ@kurwa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/19/24 05:40, Artem Ikonnikov wrote:
> According to ceph documentation "getfattr -d /some/dir" no longer displays
> the list of all extended attributes. Both CephFS kernel and FUSE clients
> hide this information.
>
> To retrieve the information you have to specify the particular attribute
> name e.g. "getfattr -n ceph.dir.rbytes /some/dir"
>
> Link: https://docs.ceph.com/en/latest/cephfs/quota/
> Signed-off-by: Artem Ikonnikov <artem@datacrunch.io>
> ---
>   Documentation/filesystems/ceph.rst | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> index 085f309ece60..6d2276a87a5a 100644
> --- a/Documentation/filesystems/ceph.rst
> +++ b/Documentation/filesystems/ceph.rst
> @@ -67,12 +67,15 @@ Snapshot names have two limitations:
>     more than 255 characters, and `<node-id>` takes 13 characters, the long
>     snapshot names can take as much as 255 - 1 - 1 - 13 = 240.
>   
> -Ceph also provides some recursive accounting on directories for nested
> -files and bytes.  That is, a 'getfattr -d foo' on any directory in the
> -system will reveal the total number of nested regular files and
> -subdirectories, and a summation of all nested file sizes.  This makes
> -the identification of large disk space consumers relatively quick, as
> -no 'du' or similar recursive scan of the file system is required.
> +Ceph also provides some recursive accounting on directories for nested files
> +and bytes.  You can run the commands::
> +
> + getfattr -n ceph.dir.rfiles /some/dir
> + getfattr -n ceph.dir.rbytes /some/dir
> +
> +to get the total number of nested files and their combined size, respectively.
> +This makes the identification of large disk space consumers relatively quick,
> +as no 'du' or similar recursive scan of the file system is required.
>   
>   Finally, Ceph also allows quotas to be set on any directory in the system.
>   The quota can restrict the number of bytes or the number of files stored

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


