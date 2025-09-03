Return-Path: <ceph-devel+bounces-3510-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 111D5B41833
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 10:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BED583A8334
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 08:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E96622E172E;
	Wed,  3 Sep 2025 08:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUrawY7T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE22E7631
	for <ceph-devel@vger.kernel.org>; Wed,  3 Sep 2025 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756887409; cv=none; b=uDz6FzeiDTf71tRhMkUREgcwsjtwl9XjUQFgGeij6ip5+ElrKt3D8rfJa07CWVRPBMoiVQevRjh7574hFuk2JMfPXbFlA3YHRRUAC0VvQ1p//8sfIbPlcv0wno17ZYhqW5RzZ2ByYFThEPXHdgBxVpcLySK7SRsEOYdutOZy7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756887409; c=relaxed/simple;
	bh=Re+e7BijoTbsCgSZ5iTUQbLfBnwaPcYBU5qrPytMDuI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KCw0WDJ+47McbvoND+6g7ZdKgAsCgdfox9GVJXHuclKe+kZSZ3Eq4YrJ9x6AKO8eRNeWjy1NoE2WZ0+ogsHyLh68YR9JGATctf6I0ciuGk5Nz9FdAdLLYwjTQPtH5L1K88t3aXMjMrzbpBL8w8t1rdNLuV6tBGO/zkU8nYqFSUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUrawY7T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G2z6mpopbPufu8fsWdtEVQ7DTC3tmoaLG19ol2Qw0vU=;
	b=PUrawY7TteGstfMyummeTcETR1tYv9AsnHaUmIcUmEODboT0dmLupO8lRtdxWIyQOIlre+
	1rf/k4WeaHprKYWw1RdoUsbgPciYBhLa4WK9las7eCClTeWGdQnwkLJ1bgsnhr0XF7r0si
	fpQmQ1Qpp3veugQ2y6Ql2l12GNNNalo=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-uPHihbpYM6e4yp9HOK9tOw-1; Wed, 03 Sep 2025 04:16:45 -0400
X-MC-Unique: uPHihbpYM6e4yp9HOK9tOw-1
X-Mimecast-MFC-AGG-ID: uPHihbpYM6e4yp9HOK9tOw_1756887405
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-53f9d707421so658664e0c.1
        for <ceph-devel@vger.kernel.org>; Wed, 03 Sep 2025 01:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887405; x=1757492205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G2z6mpopbPufu8fsWdtEVQ7DTC3tmoaLG19ol2Qw0vU=;
        b=PQCIrFVG4n4z9rBDPKxOnih3w1+5X2l9aRZuPQb8t8SICQUA83xKM5zrH9v7izOu6G
         88Hh8o5V8Njb1XghUpU4Xh2L4zlh0pzuLEarrvAb8lUx+fdSEctKT1Ec8MyJCJHQpPOA
         MN2eqMRLv2yp5+l+q+7H2oZbXpMaaCuX3l4k7qN/tyd/S36a2U6uvsDqdR8zubg+RyKW
         f2vzhU7TXyI8YKPixWRhwgZMZDVOmqOcAZhV1WizxTlfXffcLgHWxabVlkbiUEMJ5FNU
         i9kzleaZkfm7yyx7/HuIirHrboXpBfn6Z0Gxy7XnIV14aQ13XxwXoldPFCIj7mu5XtK6
         L5+g==
X-Gm-Message-State: AOJu0YzS2sjmG4vTdAFIpLDasckHhzGir5KrbqFbEfbKC0yKM8WEYh1r
	nQIJ+wvG7qoduh4lHOyYp8Zt7bQv3EQ/NzMaQ34tlHTPt+FQawfYn5eseY3Iv54Ds+i+FzISbJd
	fin9YTqFGYepk3gRbC1a9P9r7sDSwQzFsUEnXtNazbpz60UsxLvh3Z/6lRUaxQyXxr3/AoVAjiR
	X/pOCxmDdLD/F1RhpgwnEn2V1lHRuSfWTcbtTxjg==
X-Gm-Gg: ASbGncskpToeS951iTzlEkH/fUys4J43jFObG6ttNoDrA9PBkUBUvaCCubxD/JPghGZ
	HCOmxgoYGgTDjU4v2DCZ8dOTS1Uh06tFPUSU3b+JKfQkpMacCp+qF8nd7dF4Ek2qCfwq1lP6R0L
	bdlVzXAgIsUUb9VlcXoqJABQ0yIqGcLqPO51JfYlDX
X-Received: by 2002:a05:6122:481:b0:544:87e2:12fe with SMTP id 71dfb90a1353d-5449e88de88mr3961474e0c.4.1756887405234;
        Wed, 03 Sep 2025 01:16:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECS/N35Drdg76RdlbxNZjeIUpa5pkGUOiSFJbCeAeT74IRBGvY3NcFO57G8Fk6ZkCSKNJMgWfcn+XXAaDVI4w=
X-Received: by 2002:a05:6122:481:b0:544:87e2:12fe with SMTP id
 71dfb90a1353d-5449e88de88mr3961462e0c.4.1756887404889; Wed, 03 Sep 2025
 01:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902200957.126211-2-slava@dubeyko.com>
In-Reply-To: <20250902200957.126211-2-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 3 Sep 2025 11:16:33 +0300
X-Gm-Features: Ac12FXxirMUeXEEMOfPTgApw4Z7n8102_Gpg2uemNkSOmE9Hz_uIfRUN1CVjrUk
Message-ID: <CAO8a2SiikJxtRSaEPYuX51EhEYw2MCUWFCJHac62SiRXWQVEMA@mail.gmail.com>
Subject: Re: [PATCH] ceph: add in MAINTAINERS bug tracking system info
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com, 
	vdubeyko@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Tue, Sep 2, 2025 at 11:10=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> CephFS kernel client depends on declaractions in
> include/linux/ceph/. So, this folder with Ceph
> declarations should be mentioned for CephFS kernel
> client. Also, this patch adds information about
> Ceph bug tracking system.
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> cc: Alex Markuze <amarkuze@redhat.com>
> cc: Ilya Dryomov <idryomov@gmail.com>
> cc: Ceph Development <ceph-devel@vger.kernel.org>
> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dcfbd11efef..70fc6435f784 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5625,6 +5625,7 @@ M:        Xiubo Li <xiubli@redhat.com>
>  L:     ceph-devel@vger.kernel.org
>  S:     Supported
>  W:     http://ceph.com/
> +B:     https://tracker.ceph.com/
>  T:     git https://github.com/ceph/ceph-client.git
>  F:     include/linux/ceph/
>  F:     include/linux/crush/
> @@ -5636,8 +5637,10 @@ M:       Ilya Dryomov <idryomov@gmail.com>
>  L:     ceph-devel@vger.kernel.org
>  S:     Supported
>  W:     http://ceph.com/
> +B:     https://tracker.ceph.com/
>  T:     git https://github.com/ceph/ceph-client.git
>  F:     Documentation/filesystems/ceph.rst
> +F:     include/linux/ceph/
>  F:     fs/ceph/
>
>  CERTIFICATE HANDLING
> --
> 2.51.0
>


