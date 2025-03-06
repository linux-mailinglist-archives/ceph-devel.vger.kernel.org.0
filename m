Return-Path: <ceph-devel+bounces-2874-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76857A55071
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 17:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC6A01891A1E
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 16:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CF8212D7B;
	Thu,  6 Mar 2025 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fdsxtxqs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C75212D7D
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 16:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741278125; cv=none; b=YG8eWlIU/0kSWn2SBcKCx8p742/LOgDdFn0MurTMN/8pgH+EtsxWcHn8TwR8x/fCHIwmu3SLelXyZNY3v0FwSqTgI9cp4tMGopRCYqMsg9cSbUgtEX+2JE/W6VJzV4UUpbtpMkUqxLnNJ/yyq+bRWOApp2xfVJZ9SjCmC7tZlD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741278125; c=relaxed/simple;
	bh=6JEQjmrMba8qZUKzmUxEKp4TUW/usegCC4+9HVUbFao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SPj28ArKyJRHDuFdObE++XBabNeW5mwHkH5ji8lw3C3el6ql5EN6BkLrEhKG4H7LFbzOz65u7mwT4Z43E4SuM0oM0k9/fLlP7yvHSbgYnyZdfYYHbnaXBy1Tj/r5WSH+DAtpumuDJjUCm1b5bQjSepDxc1u+nAjhVF6oE//WOdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fdsxtxqs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741278123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqC+Llm1WJYyckYsZ/+upOpOsuMKvlE5dwDUUY8Zj7g=;
	b=Fdsxtxqsp+fLPkvos4SVvbAjMt1qC3CH/HsL84VquUISFb36uz/7dYVkk36vKWW5HwSj9e
	YJrr3rg5/1kTPm0KJFZTOYxVSCm8KAKHLMTTSR6JP5Q4BQz+0QT5Tp/2aTx0DAhEqAbi0Q
	yV6qd6AYugwfSv12Xp/fBpkRBL6B4yQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-w0bp8xhVOsGDC2nNYJ1oEA-1; Thu, 06 Mar 2025 11:22:01 -0500
X-MC-Unique: w0bp8xhVOsGDC2nNYJ1oEA-1
X-Mimecast-MFC-AGG-ID: w0bp8xhVOsGDC2nNYJ1oEA_1741278121
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2234bf13b47so15910385ad.0
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 08:22:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741278121; x=1741882921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqC+Llm1WJYyckYsZ/+upOpOsuMKvlE5dwDUUY8Zj7g=;
        b=MdHHlKWv7RFhQy13EMLP5F/QcwmsbhLiycvRBOVWsEUnjbQysn8eNJaUeEWihSbvgR
         yGaPVVnfSbEi6xis7T/IVQ1RQttz+GqP8OulnpA84K/0/XVZ1fmW9S/FY1U2VzE9hGWj
         R4sbhQI0AStS08CZemBLGTuo0rQhcR4XiL+nC63ZppUPdGKaQaTjnAvKPF8OpHrMkVM9
         xKtIm3jEgfqWg92JPfZqsfsJ8GvriO78dNH1rdZuntWz1hyCpuLJ8bBDPk163Px06rYa
         6g8hyJ9pegrB76jDm9R8gQUzCuxlkx1BquHW7834fyvMuDJsS3fc1YdrkL8FJigkC3oK
         SuCw==
X-Forwarded-Encrypted: i=1; AJvYcCXmn8uGdQld3Zl2HXa8QOzgmPE26Hb4vQf9jca+sokdBHUvE5f5KEtKQJIgYS77FYuJNXmxZvCioNxN@vger.kernel.org
X-Gm-Message-State: AOJu0YwcjnzOV9e99TGtqxPIQ89kBhClOyRjYprqYRY9VqDgimSlt/gx
	ovoIuG5zSoQeI9mhfuyVjjTecfRvAXV1zuqFv8ObZWDTQcH2awJaD2H/H2Z34FmR6ZP9cxAS0Hu
	+ypKV5uLqF6HpKKkT/P0RWzsTKJToxt1HCGdBTliZrVmkkmtVdrcNUpYQUXUlW/hOIvgmyXzH0G
	nbvJGM5M254QrNswl57ronJr8YmWKwt2b0ew==
X-Gm-Gg: ASbGncs98eAB2i6wCeRDSxE5DCDozN7BiEfZe7tsiAS8sWm1RK9aImTf39squvhKatG
	83SLNc0WanN9FcUJIljIyvNOwkyo5wdCu1qshysp+Nv+7cF88Qifmo75bDq2GQPv1f0lt6mgCv+
	7S6w6VQWJNdWCUhyVEpVY6nIvfCbDw28M=
X-Received: by 2002:a05:6a20:6a26:b0:1f0:e3cd:ffc0 with SMTP id adf61e73a8af0-1f544cad6dbmr117479637.38.1741278120574;
        Thu, 06 Mar 2025 08:22:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBnNiZHiJ9P1cHLuxoqkZ0Gke5p5+vnyphXWaW76LGKMfyxbwfovLX3oXnrDS2K4RsAwjCEgRVZZSj048G2+4=
X-Received: by 2002:a05:6a20:6a26:b0:1f0:e3cd:ffc0 with SMTP id
 adf61e73a8af0-1f544cad6dbmr117431637.38.1741278120028; Thu, 06 Mar 2025
 08:22:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
 <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
 <CACPzV1mpUUnxpKQFtDzd25NzwooQLyyzdRhxEsHKtt3qfh35mA@mail.gmail.com> <128444.1741270391@warthog.procyon.org.uk>
In-Reply-To: <128444.1741270391@warthog.procyon.org.uk>
From: Gregory Farnum <gfarnum@redhat.com>
Date: Thu, 6 Mar 2025 08:21:49 -0800
X-Gm-Features: AQ5f1JrunyMYAkh4fezKqE6Zg5EpuX-iNcyahs73zEQzWdI8lPNSFb7vn1fVr8Q
Message-ID: <CAJ4mKGZP2a8acd3Z7OT4UxJo-eygz30_V4Ouh05daMQ=pQv4aw@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Venky Shankar <vshankar@redhat.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 6, 2025 at 6:13=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Venky Shankar <vshankar@redhat.com> wrote:
>
> > > That's a good point, though there is no code on the client that can
> > > generate this error, I'm not convinced that this error can't be
> > > received from the OSD or the MDS. I would rather some MDS experts
> > > chime in, before taking any drastic measures.
> >
> > The OSDs could possibly return this to the client, so I don't think it
> > can be done away with.
>
> Okay... but then I think ceph has a bug in that you're assuming that the =
error
> codes on the wire are consistent between arches as mentioned with Alex.  =
I
> think you need to interject a mapping table.

Without looking at the kernel code, Ceph in general wraps all error
codes to a defined arch-neutral endianness for the wire protocol and
unwraps them into the architecture-native format when decoding. Is
that not happening here? It should happen transparently as part of the
network decoding, so when I look in fs/ceph/file.c the usage seems
fine to me, and I see include/linux/ceph/decode.h is full of functions
that specify "le" and translating that to the cpu, so it seems fine.
And yes, the OSD can return EOLDSNAPC if the client is out of date
(and certain other conditions are true).
-Greg


