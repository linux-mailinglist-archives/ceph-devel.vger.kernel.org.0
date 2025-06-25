Return-Path: <ceph-devel+bounces-3210-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3243AE7FBB
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 12:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 703B1188817A
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 10:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FB329E0EC;
	Wed, 25 Jun 2025 10:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KhnnHO/K"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E9129B23C
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848051; cv=none; b=fC83dxXCmh9O0gsFQRC+9JFrIAGR/PGhel/OK4hULWZjcVw67surG9gf7i/TTdocV2SEm2gmu1Wc+A8UNHUwicSD4wWdOWiuW/pOlfgLOe0yHLAWFWvxMq2Zip15d56dkKSzG1uJQJ6I6AYbsXu3bNpO/1LDWyFc//yzlWFZcis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848051; c=relaxed/simple;
	bh=kdRywbgWT5zbIjE0V4UnI7MGY64eaZ1GFQ7MxZL739g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bu72+6MGv4JD4/Ed7f5DKVYRXfPhNhqmIgoaV9XPHY7E8vZFxsZ68W8JxgziHJkZtT4jeG7dOL0GHJDwwkGM1IlNa5fEAvSvD1pSIoR78n9QKo1Bz5HealHLl9yIKu0GAH6Qu+CO7qUl62vDLSQQo3c3FrZwMDU9/mbdTjXUhIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KhnnHO/K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750848049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7h/KHM+Z1ETmgfw7Ga0CGtwnfJFvbJCAzq2poHb47zk=;
	b=KhnnHO/KR5UCMuhRPDX0/PKx0mo3I+iwdRdWIZqZCDn+rxA5uv4XvBjVGxreVF14/FuhJI
	vHo2C8YbID148i+n48jBFnShroc+yT6pv2D8NbcNLab8AzjZuR3nOaQcWdU9R0Q8DOAMD0
	H+uHE4PXeccJZp2EN2+Q/ooOg2PRaxU=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-Xfv-yQxqNbmVuB6xjUY88g-1; Wed, 25 Jun 2025 06:40:48 -0400
X-MC-Unique: Xfv-yQxqNbmVuB6xjUY88g-1
X-Mimecast-MFC-AGG-ID: Xfv-yQxqNbmVuB6xjUY88g_1750848047
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-4e71cf8d0beso6193913137.1
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 03:40:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750848045; x=1751452845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7h/KHM+Z1ETmgfw7Ga0CGtwnfJFvbJCAzq2poHb47zk=;
        b=BRpndCJs2iIAKrBzp/0sn/PCDwv1UDdQtcygk3wG5Zi7OUM0R0zXFZzo+PD6sapIc5
         Y9sW7wRkNTCcvdsElqPSRoaKN6vdb1gyPkwNQs5gxkshuovaSY3MLhYkP7SSBCwT9GZo
         jlVF44m35zljfaND8HwCutasBtpf4ikPNJWrgsNc4HOxOBe0EEcZCJ2K5nfzY6IKqYHz
         RaQh0DjT9MQJfmLgF6eIpO/aaRKlXoq1IdSNt2Cwtz4z6M2W2T8tWAje/1BdxE2XfnBf
         p+49uNqPbXGnbm7Xm+iQHJTOhbyAE+5479r2WeK8Eu3ToSNQNSu12lIQeqYiwfKR65jq
         +7yg==
X-Forwarded-Encrypted: i=1; AJvYcCWi5NmXV9QqC7CKAuATJmEmLKwRnq1PACKa2XQF/4jhG0ZySJtxZfH4dnqYBV1CNCXRSLmLAJd1u4yQ@vger.kernel.org
X-Gm-Message-State: AOJu0YwMhTVr5ShUYxUp9Smv2RV2bm/fJPq9ul84xjADM1cifC5sznGU
	RimsBjgUpPAzSUmtKrVG2WRVmLmKs2o1gN2+w1MGpY75JQw7xJuVkttEhblElPe02ZWBy/TNKa4
	T2fhSufxuNyxYPDemG4C2N2PN/ht6IcbPcgX1zs9P1AUlAGgq+3Ams42Y22Ls4qFigfATZJQcNM
	1hc7pYJM99EWHt64JqeaN7jbom1/vcm9C5tfW7Ag==
X-Gm-Gg: ASbGncv2LrsSoAtDF9InZ76fqvhkqm7a7sUHGy3r5fslKFqw5358JqS4FJ8yYxCHiMH
	Mvk5Eg9UIWgvJTIh/c06MlPJeenE/7yIqfZ0h6bEKEgQCB7x0LOosw5qP/curOBUCtZ97fTxB0t
	99
X-Received: by 2002:a05:6102:2927:b0:4ec:c548:e57b with SMTP id ada2fe7eead31-4ecc63b0f4fmr1247641137.0.1750848044935;
        Wed, 25 Jun 2025 03:40:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7Rrly+INsD2FyLdl36Be/L5V6Eddn3BzuS4sqrDJs6t6pJxfkEkXvuFGZkctU3cnellCkS1CHwmPPaKFihXQ=
X-Received: by 2002:a05:6102:2927:b0:4ec:c548:e57b with SMTP id
 ada2fe7eead31-4ecc63b0f4fmr1247636137.0.1750848044685; Wed, 25 Jun 2025
 03:40:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612143443.2848197-1-willy@infradead.org> <20250612143443.2848197-4-willy@infradead.org>
In-Reply-To: <20250612143443.2848197-4-willy@infradead.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 25 Jun 2025 13:40:33 +0300
X-Gm-Features: Ac12FXyMPBCBLK4e87Hspuz-o2CzX-UVv_jmEtLCyzergMQSVwUQNGmL3GwfGWY
Message-ID: <CAO8a2Sjtc9xfBjhe+MGjHwc=9vJP7pB1bwno1mgKpfZgAO1QLg@mail.gmail.com>
Subject: Re: [PATCH 3/5] direct-io: Use memzero_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good cleanup.

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Thu, Jun 12, 2025 at 5:36=E2=80=AFPM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> memzero_page() is the new name for zero_user().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/direct-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index bbd05f1a2145..111958634def 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -996,7 +996,7 @@ static int do_direct_IO(struct dio *dio, struct dio_s=
ubmit *sdio,
>                                         dio_unpin_page(dio, page);
>                                         goto out;
>                                 }
> -                               zero_user(page, from, 1 << blkbits);
> +                               memzero_page(page, from, 1 << blkbits);
>                                 sdio->block_in_file++;
>                                 from +=3D 1 << blkbits;
>                                 dio->result +=3D 1 << blkbits;
> --
> 2.47.2
>
>


