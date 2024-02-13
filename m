Return-Path: <ceph-devel+bounces-848-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A05852C6C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Feb 2024 10:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 378C01C2324C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Feb 2024 09:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C967E225CB;
	Tue, 13 Feb 2024 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8UrtHFc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03C352F78
	for <ceph-devel@vger.kernel.org>; Tue, 13 Feb 2024 09:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707816871; cv=none; b=VH4ydaL/LLcRI0tg2RvwXX4EpWfNQmKSc/VqUtUSjJGXdGNCGrBfA1qQ4nBt8ZUkgjaIcBj4aENkkO5QMDHbDT/q4/SApZ8JFWmyg31LUIRRboSCbjxr64/mNZ9fOR7qbbST9N8psNa2QGs8yYDa//2Y6AYKR29q9Bwp2bPIxjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707816871; c=relaxed/simple;
	bh=2l8MkVOUAEthXnV18WUWF1B274CVM33C717XQOVlOiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMyOhyhlYWx3rVwfxahuYQWxJMQs6wWZNJ8wiZ2av0kfCER1Y+T5Qd5T6HFwrULoEHjDYARDbXoYiaxFGGww7f23lkDXwpuP3w5CVEyZ4IEhZGrTFNDy6OmH9ZE1M/6Kux/bGEeG+9qAsVkX3rNKKmXlptN7C9hx9Qb94i5ibhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8UrtHFc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707816868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dYTmYOFse1Xva+3pb73kJxe85cj1h9td+QrlShQmPro=;
	b=R8UrtHFcm47WqzjuCvzUvQh0HCv9HcB9Lb4dQyaPoAkus7V7SmsfF8g/T4NMWfn4o7TYtT
	0Y+qwN553O3CJSwXv6j6A0WK2mApthUv4hgu+zb+ODnVCxZvjtSVaWk1ojmZCP6HGLaRXm
	DtueItqmcM4DidvCgPD+m8LaJl1/kSg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-9UhDGrJjNqm51PaCl-qLpQ-1; Tue, 13 Feb 2024 04:34:27 -0500
X-MC-Unique: 9UhDGrJjNqm51PaCl-qLpQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a3cfc0287faso21066766b.2
        for <ceph-devel@vger.kernel.org>; Tue, 13 Feb 2024 01:34:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707816866; x=1708421666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dYTmYOFse1Xva+3pb73kJxe85cj1h9td+QrlShQmPro=;
        b=RbH8jEkDQfGtFoaamDODqyvRH7ECrjwv6iPFAff8x+T++Bx3js0Yjk6TLnnE9FiloY
         z4dB16GsWXjyp3o+bXsurAtI8RBnPbjvVoAuODCEUUyvHxpAQNYIsVNMr39JxPgqlUVG
         +H2FyXNZwJ4pu2hkWNY8196UHzhtTxuqtlsYg/1gjcytx2XA2hYNJodUSXCCQIor+LhP
         ov9UFvp36lGLz3ud7gAnmDqB7cjsdY/venZ/YKvxyc+fS6R87uPF3TA/WpNKBMatHKyM
         F0N08blCFeQloM2T88yxOyLqqYXregWWF+D0I08mKUvHlCDX7A2jK7JQ/Dc+6Fiso0dB
         lZQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIxBLsbLzW47039sbFeKXLzvr7TNXlvrfmvJKCkcn7Fj8rL+Iid829T/5vrYffRs17iD5LZOylxwLzgMvVz2p3C488KpwuVC5yRQ==
X-Gm-Message-State: AOJu0YwtHWsx6jXOIwKAtvuuhxO2lFLe28OT97vFyA12RnQwjV89tw7M
	ewqrIeeE41Xn8D98bNzjVtoF5ageuZzTZaUOZSie031+u2nXvVJQviOKPIByG5exiXcNsldZwin
	48TCnR9Z9hKrDm6l6JSzSr9LYYpw577RNPWvPo3F4CauWHEfOu6BtJUOkxJdOkj3x3pB7X2XrrP
	Y8N4894grxnB6IauvX7fBjhO33xRMS0LN80Q==
X-Received: by 2002:a17:906:d95:b0:a38:916e:a4f8 with SMTP id m21-20020a1709060d9500b00a38916ea4f8mr6377550eji.2.1707816866187;
        Tue, 13 Feb 2024 01:34:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmx8kbdq9XPAsvp70uU781KLj624Hdua23AHoxE9R/Vuhqs2wSmiH3CML05BafbcAhdXXN1X4r/WbF4EfT6Dc=
X-Received: by 2002:a17:906:d95:b0:a38:916e:a4f8 with SMTP id
 m21-20020a1709060d9500b00a38916ea4f8mr6377538eji.2.1707816865803; Tue, 13 Feb
 2024 01:34:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240117042758.700349-1-xiubli@redhat.com> <CACPzV1mfFu1wxeUXg2WU++8YsXe7gHz_Pk278sHQ=jOvEpLPTQ@mail.gmail.com>
In-Reply-To: <CACPzV1mfFu1wxeUXg2WU++8YsXe7gHz_Pk278sHQ=jOvEpLPTQ@mail.gmail.com>
From: Milind Changire <mchangir@redhat.com>
Date: Tue, 13 Feb 2024 15:03:49 +0530
Message-ID: <CAED=hWCe9ZhCi3GOXTEU9JX4WA1BJK99Z_6dfr-Yn1x6iiba1A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ceph: fix caps revocation stuck
To: Venky Shankar <vshankar@redhat.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	jlayton@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 12, 2024 at 8:23=E2=80=AFPM Venky Shankar <vshankar@redhat.com>=
 wrote:
>
> On Wed, Jan 17, 2024 at 10:00=E2=80=AFAM <xiubli@redhat.com> wrote:
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > V3:
> > - reuse the cap_wq instead of using the system wq
> >
> > V2:
> > - Just remove the "[1/3] ceph: do not break the loop if CEPH_I_FLUSH is
> > set" patch from V1, which is causing a regression in
> > https://tracker.ceph.com/issues/63298
> >
> >
> > Xiubo Li (2):
> >   ceph: always queue a writeback when revoking the Fb caps
> >   ceph: add ceph_cap_unlink_work to fire check_caps() immediately
> >
> >  fs/ceph/caps.c       | 65 +++++++++++++++++++++++++++-----------------
> >  fs/ceph/mds_client.c | 48 ++++++++++++++++++++++++++++++++
> >  fs/ceph/mds_client.h |  5 ++++
> >  3 files changed, 93 insertions(+), 25 deletions(-)
> >
> > --
> > 2.43.0
> >
>
> Tested-by: Venky Shankar <vshankar@redhat.com>
>
Reviewed-by: Milind Changire <mchangir@redhat.com>

> --
> Cheers,
> Venky
>


--=20
Milind


