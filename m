Return-Path: <ceph-devel+bounces-2607-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9271A21E34
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2025 14:54:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F94318866FB
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2025 13:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BA9130A7D;
	Wed, 29 Jan 2025 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NhyuvKF7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3A02C9D
	for <ceph-devel@vger.kernel.org>; Wed, 29 Jan 2025 13:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738158868; cv=none; b=jTRviFESyBxjeteJQRjFC/rP1nxt1srGRgSjmdT1/u46K8DcpkukMAsyAMS5l9e3tAJNfsNDriR0Zn7hKnZSto6RLKLb94iyh4ZjlTWF8J5mp4yGTm003Br5v+Q/4Yd2xg4tr8LT+hBWU3ZsjJiFmY/z2kdI5eAn9fC6Z+Kd26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738158868; c=relaxed/simple;
	bh=eRwhaLv5TWLvY+t+PzV+r0OKnG5yDvaTT1koG0K3dho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NFVeaTfmgcB3iWu2T4J/smZZz39ybEV411gcOlcKRO0933spjBYTRIiY591ak3gJDGQsMx3G2rygBW4vJQVTXLgcd025P0mqsPMAIXpJkxPC/1+IBRTlikcv563Kw6c4+ITakKn8fsIUKaUMZkQwzaWKIFF8zKFONESYabAPm2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NhyuvKF7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738158865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oOlu6dB3//zUYOhcqFla8h2uJ/qtjTb83w7ohytxlZ4=;
	b=NhyuvKF7fgHKJ3IcbWq4FEohxeHgudI5PHy5Iegaytt99t1Y0DeYn8WCSmJFYWwwERYxcD
	tiU5BNE81i2oNHTKD0xFUDsienEl1zAcXTCeD2y6mybMmwpJgNr8COrSkNSiX4N+TOGJiM
	nzxmSd5lmlqiV7erYOem7Ix5vUpO6Sg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-1F6plL8xMMy701BUeWubpw-1; Wed, 29 Jan 2025 08:54:24 -0500
X-MC-Unique: 1F6plL8xMMy701BUeWubpw-1
X-Mimecast-MFC-AGG-ID: 1F6plL8xMMy701BUeWubpw
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aab954d1116so676923266b.3
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jan 2025 05:54:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738158863; x=1738763663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOlu6dB3//zUYOhcqFla8h2uJ/qtjTb83w7ohytxlZ4=;
        b=JpUd6stVs0Y+Iqr8vwhDXhpWjjxfI8RpYfTpxofGw4eOOVKKhD04t/6OxPzi4EWare
         OcBsShhLXE3Ec2bdwz1/262+BqXG/nf6TNUjHOxsx3zT3/5jlIIL85iCvkYu/HusfYBN
         nLKelkxgOn4/mtq+vC4REch3GaVxZosfJFhtMRwqwBFJKzL0G5S9EpPufGLlZboqYd+O
         oYqVDXRxVDDUqpLt9j0JuTJcag9QQ9cE+BZqHXgCBleqmKAEsQOM+zpOB6xDW0E+NEoq
         qeTTag2jLKGAJ8zDqGwlOjRtbmOgox3i9A10JSqfJKUf8IiyDNgNg3QWOd1XT0TjbAZ4
         AoUw==
X-Forwarded-Encrypted: i=1; AJvYcCWyoDGzchpfs2rcMiyrhXFPXGpVsmHRA784wUsBGkarnYLDSFM4/IqDX2TK+CgQilTtw9OLfH5Z95Nj@vger.kernel.org
X-Gm-Message-State: AOJu0YzwEjLHinOTK1sanEdAU8GOPOxD6zdJ+vYcRgukYBpl4CrS3/BR
	DUD24yMQom0D/dBg6u3xRquwHU9VFWVczjquBsdR+n5lyQTKyjXAizqsJavGz2bnBYsvqvX/vHJ
	V0F/kYJlVoQYxfd0IIJY8dmj1gY3NRZTbJ1dKJzMNpAlAbF1b+XR9/cSopOZHUIuxGe24P+NXEE
	UGF6TMtoyr4lHsp6YL82i3FmJVM0ulATmU4A==
X-Gm-Gg: ASbGncuu+HmbaqSt3ybGtpgTfWqDQJKnhvDvvU7myY/KXldTTzCGVxRnLfP10H8wKI0
	ZRI8gAOkBNvOKSbAc5rQ49DXMIuRNkMzZLWDLKctL8OqJsFfYaWBDWpMdL4lgOw==
X-Received: by 2002:a17:906:608f:b0:ab6:d575:3c4c with SMTP id a640c23a62f3a-ab6d5753e0cmr160660766b.17.1738158862907;
        Wed, 29 Jan 2025 05:54:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGEoSRFizNZ7LApK6I1ExjTAM8b67HHexrPzWrlsDcchWhdruOGgR01UriVscVcl71uuggIobEF8/2Lt28xRMU=
X-Received: by 2002:a17:906:608f:b0:ab6:d575:3c4c with SMTP id
 a640c23a62f3a-ab6d5753e0cmr160659466b.17.1738158862523; Wed, 29 Jan 2025
 05:54:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d81a04646f76e0b65cd1e075ab3d410c4b9c3876.camel@ibm.com>
 <3469649.1738083455@warthog.procyon.org.uk> <3406497.1738080815@warthog.procyon.org.uk>
 <c79589542404f2b73bcdbdc03d65aed0df17d799.camel@ibm.com> <20250117035044.23309-1-slava@dubeyko.com>
 <988267.1737365634@warthog.procyon.org.uk> <CAO8a2SgkzNQN_S=nKO5QXLG=yQ=x-AaKpFvDoCKz3B_jwBuALQ@mail.gmail.com>
 <3532744.1738094469@warthog.procyon.org.uk> <3541166.1738103654@warthog.procyon.org.uk>
 <dbf086dc3113448cb4efaeee144ad01d39d83ea3.camel@ibm.com> <CAO8a2SjrDL5TqW70P3yyqv8X-B5jfQRg-eMTs9Nbntr8=Mwbog@mail.gmail.com>
 <3669175.1738158126@warthog.procyon.org.uk>
In-Reply-To: <3669175.1738158126@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 29 Jan 2025 15:54:11 +0200
X-Gm-Features: AWEUYZmRlTOFqntcqaf2lh13EYbDsYagSNYklA86w8T9p1Y0tYv9fQUzl6VDPoo
Message-ID: <CAO8a2Sg-uQdpAq+4K0y6=bzx7ACszm1Z2dZuhDhyMJ254mKL=g@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: Fix kernel crash in generic/397 test
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"slava@dubeyko.com" <slava@dubeyko.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yeah, all tests are fully independent.
Just make sure you see them being executed or you can just run them stand a=
lone.
e.g., sudo ./check generic/429

On Wed, Jan 29, 2025 at 3:42=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > FYI, This the set of fscrypt of tests that keep failing, w/o this patch=
.
> > Many of these revoke keys mid I/O.
> > generic/397
> > generic/421  #Test revoking an encryption key during concurrent I/O.
> > generic/429. #Test revoking an encryption key during concurrent I/O.
> > And additional fscrypt races
> > generic/440. #Test revoking an encryption key during concurrent I/O.
> > generic/580  #Testing the different keyring policies - also revokes
> > keys on open files
> > generic/593  #Test adding a key to a filesystem's fscrypt keyring via
> > an "fscrypt-provisioning" keyring key.
> > generic/595  #Test revoking an encryption key during concurrent I/O.
>
> I presume I don't need to add a key and that these do it for themselves?
>
> David
>


