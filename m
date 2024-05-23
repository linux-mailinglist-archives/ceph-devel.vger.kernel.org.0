Return-Path: <ceph-devel+bounces-1160-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B28F8CCB25
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2024 05:31:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85821B2127B
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2024 03:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5030C2AD1C;
	Thu, 23 May 2024 03:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H8UBi69p"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF7B17F7
	for <ceph-devel@vger.kernel.org>; Thu, 23 May 2024 03:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716435112; cv=none; b=HGPdA/zqsd4KrW8lFyble7rAB/Iw7EhBMezAz41V5H5cg4eLfG4Ztc18wW3UXobsL5GTTD01tu3bO2ThCtu6mb1y9+nY8l86Nn2qI39nRviDARtjKJIjOlTN74zs+i+kwVhmhfzwf0cxxzENIlLJJQ1GVplTnQpH500QBNWnB3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716435112; c=relaxed/simple;
	bh=aylDq58MenYjlMZi6CNs6bS30BIzn2OxHbF42AZxZyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FumGqXhXYL68Q/GEu6XZPVLSiXu00Asi1RXnDGyc1MgDOVWOLDXekVvk5SsPEJtuy3Z9q2dtc9kH2moVQUe1sFf10LBDw637zTCzVWqllGoZLsWxZoVHhEaLlpCbWOioFUxflZ9joIsvBPMFwx8nBO2mP/nBU3lxvcuxpGRakvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H8UBi69p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716435108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELRQXbtQbAP8bHuwhParseUXBYM2Qs3oVRAxCSJvFGM=;
	b=H8UBi69p6PqcebF6b98WbU/QDtRoj+GXtnrI5xd4NDU/o+398nuIDL3vhNJ6DPI1doz8hM
	OscGLtI8inhEqOLJGd/PcXB4DAyPFJUIYtpqnWwyyU9ATmmJPlEQrACLJdBkMPpQhdYWaI
	X+qzdbD/LaCRfoU1eQYKCbutDWiCPak=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-j5IPywupPiuTEYGlIkSvBA-1; Wed, 22 May 2024 23:31:46 -0400
X-MC-Unique: j5IPywupPiuTEYGlIkSvBA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a6240381e41so10744766b.3
        for <ceph-devel@vger.kernel.org>; Wed, 22 May 2024 20:31:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716435105; x=1717039905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ELRQXbtQbAP8bHuwhParseUXBYM2Qs3oVRAxCSJvFGM=;
        b=pRwP6lxRpw/lbdZz8e5ypuC+d/+cUMLMMuQwuqjsW3N+Qvx+EEb5wuxZ4+92S7Tbbz
         v0/TxNNdCoG1IuNSLzAPekOFIzXxcs0hvXhsE23OscQpZNbIq364A7p1fOCwTd+XFcWf
         UK2YrATiB93WIfyeAFgIGCipf9pfR77YoQ9JsYGwYcPouY3WENunWXN3zJNXoksf1kRC
         +y/5AXUou0f7Zu7QKjqA5k5fRIq18vTEERs3qVgjSE+zf4cDxtgCAFOiA/QI4AAcYin6
         pxSUDU1X1Td6or6CSsw4wPWEEu7rpG+YuEeFrUdySYonk0NJHNaZdA9Mhw87yuaSavmx
         lJgg==
X-Forwarded-Encrypted: i=1; AJvYcCXqQM94+u4DkCxX8CUk+hItrtx1mTs8wups8wUr6iO9RUtPhfBggOLcxpZEP48UgXuARFCE4AJAwEGOe53PZxuepyy3Gu/JZi3Yjg==
X-Gm-Message-State: AOJu0YwdAOxmN8n/gxcZETHIEk9rqgDreX4ttvoAKj23trRfKZgEWnmH
	4hWuqxyYKO8RLtc0HVer6iUXlXABSbQ3lI5ax0HPUiDQBxcJ8ezJPEyIwLRIKPSgLFGRaE7Ua2b
	aQB3mnwTpNlX1FK6DV+9yF4qJqW8t7TAoKPtJqdIHPpfa2BmLPRp74rrS4bh0NKLApNBt8umYEi
	5KA4+vnjn3NTeVCv7h7cf73c3i0J5l9ROVMxpCs35+Hg==
X-Received: by 2002:a17:906:c057:b0:a5c:df6b:a9b5 with SMTP id a640c23a62f3a-a6228198c3emr229420766b.59.1716435104965;
        Wed, 22 May 2024 20:31:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGikwxvbHLnjRkGVhf1saRpimfaJzTHVsPcM22bKc4tTK9tyj/qYhY51kUI9tUctJ/IpBRFlJkwvZYEvmur9TM=
X-Received: by 2002:a17:906:c057:b0:a5c:df6b:a9b5 with SMTP id
 a640c23a62f3a-a6228198c3emr229419566b.59.1716435104603; Wed, 22 May 2024
 20:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418142019.133191-1-xiubli@redhat.com>
In-Reply-To: <20240418142019.133191-1-xiubli@redhat.com>
From: Milind Changire <mchangir@redhat.com>
Date: Thu, 23 May 2024 09:01:08 +0530
Message-ID: <CAED=hWC7A4WRFV3Nj-w3Tyg92hWOgXtyzaJWBE2e1AAonH7h6g@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] ceph: check the cephx mds auth access in client side
To: xiubli@redhat.com
Cc: idryomov@gmail.com, ceph-devel@vger.kernel.org, vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

approved

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Thu, Apr 18, 2024 at 7:52=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> V5:
>  - fix incorrect git_t parsing, it should be int32_t.
>
> Xiubo Li (6):
>   ceph: save the cap_auths in client when session being opened
>   ceph: add ceph_mds_check_access() helper support
>   ceph: check the cephx mds auth access for setattr
>   ceph: check the cephx mds auth access for open
>   ceph: check the cephx mds auth access for async dirop
>   ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
>
>  fs/ceph/dir.c        |  28 +++++
>  fs/ceph/file.c       |  66 ++++++++++-
>  fs/ceph/inode.c      |  46 ++++++--
>  fs/ceph/mds_client.c | 270 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/mds_client.h |  28 ++++-
>  5 files changed, 425 insertions(+), 13 deletions(-)
>
> --
> 2.43.0
>


--=20
Milind


