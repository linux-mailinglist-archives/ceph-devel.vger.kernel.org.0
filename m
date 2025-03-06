Return-Path: <ceph-devel+bounces-2875-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02486A552C3
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 18:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2893C3A8087
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 17:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EA92116F2;
	Thu,  6 Mar 2025 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uj9DeytJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659981DE4EC
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281547; cv=none; b=OJnNeHlH/6wfjGxzHu8hNZtNNBKl59xqiFEu3NlDpgTttBMpjNSEpZcXiIQ4YKOkxXWwrOFSNr2pFSlCJOnmjRnNwNurEPfmGOx8EAqVkHcbYJf4k4seDQ2bvEwcuynOc0qpFWFzxV0nBgg4Gk68zrfFcaE/qawxJ1Jlj7Btfys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281547; c=relaxed/simple;
	bh=1zk/Wf5UBNnW+CYKHKRvUx81qFWSHkXU/Q2Txv1Mg1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GyDZdPQTbhWmb5HfU77CF///Ctmz97C6QN1TFf6ndVOIi0CQTt/a9rwliWO3Jm61wwECM6hbwU0S7sVangqgJF3w1AZC79rAfEo0upbLlcg83BCZiMn7oa5gNL0dFPe/vT8fsH78/98lo0AilUThvusWrw3ng7BiHQXBgj1zrP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uj9DeytJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741281544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUWoEwD1QtHX1NkxE737fq82KwPX2Nk79R3EEcVwNlY=;
	b=Uj9DeytJUdPw0Jz1TPjrg9hIvX8clwOaZt8n5cyG7HfDwAGU8QWn4GJKMhF9LDAlg7a84E
	sEytR24OAgeGU//rV2u1scXs7CO+wYQr7mPKEFSpzaB4j76aHuHMBXM/CURiIaSlc3imhe
	fKaMQer0kDL/frdUU5fl6aJL5yuyUzs=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-U5LDySs5O1-KDy53tMzuPQ-1; Thu, 06 Mar 2025 12:19:02 -0500
X-MC-Unique: U5LDySs5O1-KDy53tMzuPQ-1
X-Mimecast-MFC-AGG-ID: U5LDySs5O1-KDy53tMzuPQ_1741281542
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-86d376bc992so886062241.3
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 09:19:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741281542; x=1741886342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUWoEwD1QtHX1NkxE737fq82KwPX2Nk79R3EEcVwNlY=;
        b=SFNy+QG0K1TmOqocYzrsMEWHZg6onskianAzWmIRgxFYQJ5N0cLjruR5OvzKRekyof
         4yljSLzjzSyhXJARj+MJNv0X94RVEktjQwu4fU95OCDxH7RCYPiw3l4bByZS7bb08HPU
         aEc1WUaxDx1YcBqaWyTurgtPlJMCowjTmFtVGWmTj2SduzzHYmMydRABFsXJvn25tGI4
         RhopQw4dq6McyEqVO2gUjipRZit/CWpkwQfINje4SC3lC0//hptGDNaHLC/UAqgHiveh
         8lXPjbV5W016K8GZYmfENp0QPsE2/vq93BaGhfvrSl27+PS0fnJtDVyCCXIdRpHN1EKn
         11QA==
X-Forwarded-Encrypted: i=1; AJvYcCXpZoLMRpzjGA8lTSNYlzLK5uFxfOwPHR/bixA7NMna1m7AIfy+D+ovzR/Huh073D0q8oeKPjkaiqMY@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7k6yX0JiXL/7ifqDDTwYjpRlEFB1rAcXsY1AWjxltEGcqDzh3
	hdEhSa+wZTFlQQclH56IVCW/LBdtzq2Xj+cBKhUHxSHINy0+ipAwSe4B48uSxlvVeZ9uYeU5y2s
	JqUCL07wAIYZ19i6uozmNrX8B+v3iuEjnRvrLq4Pboftjk0zEgVoVNyCZ5vsxFLjtw3a7EPYESO
	eQi3pabrEsfUN3IektNuchQIOAw7rVVMrzlQ==
X-Gm-Gg: ASbGnctomwsDkORHE4PCVBBKp9mtJR4vvyjGwgp7lWpONK0oZQrnwH2QnAlX+PiL+mZ
	erx3Y5ITjY7t4idWUnp6bQgv60r9KaHy03wTnpzQciogxz0cJV0fmwhIAAf7qPlFXjRbK8k8i
X-Received: by 2002:a05:6102:5490:b0:4c1:9b88:5c30 with SMTP id ada2fe7eead31-4c2e292962emr5979449137.19.1741281542257;
        Thu, 06 Mar 2025 09:19:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7spgLqpPQaIcIR+gCiOtfl1Cc6hZYDhCnOcThE+Z2s7vNWkkQetRZiUqTe+9qs6bZrerq/C7urJCzh9HnSNo=
X-Received: by 2002:a05:6102:5490:b0:4c1:9b88:5c30 with SMTP id
 ada2fe7eead31-4c2e292962emr5979396137.19.1741281541943; Thu, 06 Mar 2025
 09:19:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
 <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
 <CACPzV1mpUUnxpKQFtDzd25NzwooQLyyzdRhxEsHKtt3qfh35mA@mail.gmail.com>
 <128444.1741270391@warthog.procyon.org.uk> <CAJ4mKGZP2a8acd3Z7OT4UxJo-eygz30_V4Ouh05daMQ=pQv4aw@mail.gmail.com>
In-Reply-To: <CAJ4mKGZP2a8acd3Z7OT4UxJo-eygz30_V4Ouh05daMQ=pQv4aw@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 6 Mar 2025 19:18:51 +0200
X-Gm-Features: AQ5f1JpQcoMH0pu_ANh7Fi3mDGR-c82TH6fAs4PV2crn8yOt0NZj2cZVfepYRdc
Message-ID: <CAO8a2ShjbUuk9_+9P9oVcgTU87ZASNpa735xOyC+tMetL13bdA@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: Gregory Farnum <gfarnum@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's not about endians. It's just about the fact that some linux
arches define the error code of EOLDSNAPC/ERETRY to a different
number.

On Thu, Mar 6, 2025 at 6:22=E2=80=AFPM Gregory Farnum <gfarnum@redhat.com> =
wrote:
>
> On Thu, Mar 6, 2025 at 6:13=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
> >
> > Venky Shankar <vshankar@redhat.com> wrote:
> >
> > > > That's a good point, though there is no code on the client that can
> > > > generate this error, I'm not convinced that this error can't be
> > > > received from the OSD or the MDS. I would rather some MDS experts
> > > > chime in, before taking any drastic measures.
> > >
> > > The OSDs could possibly return this to the client, so I don't think i=
t
> > > can be done away with.
> >
> > Okay... but then I think ceph has a bug in that you're assuming that th=
e error
> > codes on the wire are consistent between arches as mentioned with Alex.=
  I
> > think you need to interject a mapping table.
>
> Without looking at the kernel code, Ceph in general wraps all error
> codes to a defined arch-neutral endianness for the wire protocol and
> unwraps them into the architecture-native format when decoding. Is
> that not happening here? It should happen transparently as part of the
> network decoding, so when I look in fs/ceph/file.c the usage seems
> fine to me, and I see include/linux/ceph/decode.h is full of functions
> that specify "le" and translating that to the cpu, so it seems fine.
> And yes, the OSD can return EOLDSNAPC if the client is out of date
> (and certain other conditions are true).
> -Greg
>


