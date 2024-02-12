Return-Path: <ceph-devel+bounces-844-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC85185175C
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Feb 2024 15:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F5A282760
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Feb 2024 14:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463CF3B782;
	Mon, 12 Feb 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q7NB21e7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C47D3B297
	for <ceph-devel@vger.kernel.org>; Mon, 12 Feb 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707749634; cv=none; b=fBhYB+CTtRUrkuHYi3WS6v+wxPg3WtFEPsA7sl6GxEL8xj9koN11brBWx7SDWoBnFReHQC133KtbyU9MY7d/EcFhfhknG33v5605FvK5LfsSPdEzVJLSJeMY7kPsY1y8skv3OQr6MEEQDt+O4GSmp/O4/VTea98AbP4QuT/PK5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707749634; c=relaxed/simple;
	bh=h6vfCFN2INMQx4LAfXQrE1hwkKGKW5bGTzhNI3lmK+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uvpqMm+T7fujBmVSkmm7o1WCuqmnBb5eIaBRyi2+hFpEfG8BjVmW2Xllu062oE08z9I+z7nfKb3RfAucOI4W82C92aWCcXFj8J4GeGWzbayAgyJzIsZV8aADzm4tvRwPhew2AbvyM/UxuTXMj0SEMHMrKw+8JZp46BlGuIn6lXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q7NB21e7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707749631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xaQiqnm66zQg6QzqXIxm0S/RvBDKgce8g8MfDyXk5ZE=;
	b=Q7NB21e7qEgtYIbhGN+fiid+1WTi88BXGatRZ+esgf8O6SOrKQxOJZ0T0j498WkCY9YGXj
	/qq5zAJutX7S18LEXGsbKPbYXSkm0rRUCxO739+lPlZidPqj2PgniicxGt6fxZOYWzZIoa
	18PEnXFqRjomJpgbJfx4MhJq0inVv0E=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-fAhW1Z6-O_WBKKMxNrVJ2w-1; Mon, 12 Feb 2024 09:53:50 -0500
X-MC-Unique: fAhW1Z6-O_WBKKMxNrVJ2w-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2d100e37cc1so4425231fa.3
        for <ceph-devel@vger.kernel.org>; Mon, 12 Feb 2024 06:53:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707749628; x=1708354428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xaQiqnm66zQg6QzqXIxm0S/RvBDKgce8g8MfDyXk5ZE=;
        b=s6RVl5NnlK6u4GVhP55ZcT0roCWmxkOgn+HHB5//7Evs5uh9kf96VNbqxVH6wG3gqv
         fQMuEcMirmDsRi7pqsi6cGlsP+HoaWx+66Xojoat5bjyTLowi/ZXNKC4yfVTFIapoLEA
         qOcygnLW4AH+ylho1OXOWdmC75h4i4BiyDEUZhQd/m5340Bve8kFAm2fFTjJ2+CbXixH
         zNYpMB7B1tp/MPIVhP/tA6uxKEx4GL8VhV1Um4dU5oFwMAPpvBCrPbLziiTJ7Wq1lqG8
         yQsI+TmN9b2QTvWpT01nRE5d8hwWjBVAODZvANQgz9pck7EiU5Iay04aNWKaBAOXID9C
         eKig==
X-Gm-Message-State: AOJu0YxJD4dPx2CfHvAAczceuB+QVNT/ChBryvKSpn328lt6HsqfVREL
	fCG9/F2zG+tVy6586qmpl+FAMGjG52STVx6RoPA+y+ugr2B3S/2QZiozv+HMMaPz9NYgimgVjkq
	aHHggJ+FLJ5A7eDth9RYs9kdvsxqkyAn2mb2PAoM/7i8OoQzKWIVCzE9GC1msbKfmwYPue6X5Yo
	E2paGLKsVCUM2525KYnIA6NHkKUVXI2cb5wFdOpEG6dA==
X-Received: by 2002:a2e:9813:0:b0:2d0:c9b5:7257 with SMTP id a19-20020a2e9813000000b002d0c9b57257mr4685530ljj.8.1707749628030;
        Mon, 12 Feb 2024 06:53:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHq7R01QIC+UvLaFBkuCp4kP1jfB3xYSMhpUriRJ3wkiGC3oPPLv09peI/hr01qS9XdkJ+4T292p+dA/o0gsiI=
X-Received: by 2002:a2e:9813:0:b0:2d0:c9b5:7257 with SMTP id
 a19-20020a2e9813000000b002d0c9b57257mr4685513ljj.8.1707749627683; Mon, 12 Feb
 2024 06:53:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117042758.700349-1-xiubli@redhat.com>
In-Reply-To: <20240117042758.700349-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Mon, 12 Feb 2024 20:23:11 +0530
Message-ID: <CACPzV1mfFu1wxeUXg2WU++8YsXe7gHz_Pk278sHQ=jOvEpLPTQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ceph: fix caps revocation stuck
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 17, 2024 at 10:00=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> V3:
> - reuse the cap_wq instead of using the system wq
>
> V2:
> - Just remove the "[1/3] ceph: do not break the loop if CEPH_I_FLUSH is
> set" patch from V1, which is causing a regression in
> https://tracker.ceph.com/issues/63298
>
>
> Xiubo Li (2):
>   ceph: always queue a writeback when revoking the Fb caps
>   ceph: add ceph_cap_unlink_work to fire check_caps() immediately
>
>  fs/ceph/caps.c       | 65 +++++++++++++++++++++++++++-----------------
>  fs/ceph/mds_client.c | 48 ++++++++++++++++++++++++++++++++
>  fs/ceph/mds_client.h |  5 ++++
>  3 files changed, 93 insertions(+), 25 deletions(-)
>
> --
> 2.43.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


