Return-Path: <ceph-devel+bounces-1809-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB5B975B83
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 22:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4221C21113
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 20:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3DC91BB6A6;
	Wed, 11 Sep 2024 20:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uyo0bp9t"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFBB1BB699
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 20:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085687; cv=none; b=AAYh2OXOwCYsgdNHjLYNbSFRig2BBIHQQEc6DCiF4HM8OjdXohlr12ku+C9pleieU4KJWw9bmgEMjqipNiP5gpBYsK04yXJm9WbSiUYTHEg2IvKSWJOglH94wlTEMSJh1Zh6ovmng8bbQ7yJH7IODqe9XItK1wZXpdWg8f+gC00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085687; c=relaxed/simple;
	bh=OsSe0iXO1X2k004OCN4aio3yNszGQTd/Jn30DawwnG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwznSZAAfgOAOYrmjJ+LDKhR96QmUO1mofZp5/GoOwYbcvXgYBZJPpRyWreDjivC5sAow8tk9n6duWchXbe9GaiSVkL/55lD8or0d0cXrcuwGFlJpF6/7ZscaKkhJy5UC2+YE+HJl00uMFSdbBqTUciytJvJY2PBi662p+f+E2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uyo0bp9t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726085684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OsSe0iXO1X2k004OCN4aio3yNszGQTd/Jn30DawwnG8=;
	b=Uyo0bp9t91uOz0L8+YMhxx+x81X/vBtbIsUJtkyhsVHDzmC20krsPDKM2Cs0xad7r+S9ZH
	qOf0LocNmldLHB3z6MRYwTyfRuuPYwTEQlKUgZRGrYttV6tdmhXHW1ZefY3kJdCAhbbGcm
	JsBbxX74PCQ5kOuOEo/B7oRWuwEZYpI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-PO6BKwp_ObySDQs7zYU9bg-1; Wed, 11 Sep 2024 16:14:42 -0400
X-MC-Unique: PO6BKwp_ObySDQs7zYU9bg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7a99fdae7bbso100042985a.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 13:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085682; x=1726690482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OsSe0iXO1X2k004OCN4aio3yNszGQTd/Jn30DawwnG8=;
        b=e8xlkIkiMieJj5otNL3snyQzm+QRPo//GPp5NZhSQvHxf+dlH7+drh1JaCfH0AJebW
         0sQrgnSIlBqgSoEXuYkX4JpfbJ0V4ibJ956b5NgCUjtoTdgn2rEczULShcoH2qOjGerG
         QXT49w1SExlDoMBJDwWrpXPj2PIY4VL0Jl4ssv/PP6CeGDiuOihhLTzwl5Xwdx9JkXwB
         qemu72yNvUj0csDFNE5TrnaNesuabHn0dZDX/hKxVBuOvtjnFj1cWfLhhbKi/8AP9llS
         9E7vLM5JSWBj6y9RTFvie4Yze2TYTRjob9+JZSv7Px2vU4K4R4ytKJ8VhhPdvu+M7y17
         9b8g==
X-Forwarded-Encrypted: i=1; AJvYcCXacWW0INIRsiYYFTTn8+UJ/FhYug4RUhDaGMuEQS76H71dqaSjE6DwGMYUntk+aZl9+mcsNaNo8RkC@vger.kernel.org
X-Gm-Message-State: AOJu0YxpPLN8PIgUS9U7Bsp5QrMRwUF4rxqGYmYFDNSaKcMchYlNX62C
	/IhqGE+7QjtbQORF5XJLUMUqMffgwVu7UdXpM87fUc2yRH/opVqL4wb7MRd4aglxCNjQpzn8S4F
	aywDvon/ICi+w9k+IPu9ysUanMW35hGccxb0M4paAtIlB0D+kpoLwhJtxm0qIOPesHsUwmbONPl
	n+drLRN4hvsebORsmw0CD3IK9YGNVGUTnyEQ==
X-Received: by 2002:a05:620a:1996:b0:7a9:aa6c:f15d with SMTP id af79cd13be357-7a9e5f7aeccmr74773985a.58.1726085681696;
        Wed, 11 Sep 2024 13:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGYM9uFHo7eKZPOtqQHJZ2lGVoqcP+0rkdbBe7z/EI3IXviO6dh6tVJn98//HiyWnJ7GZ2OTU9TzgULozRBquw=
X-Received: by 2002:a05:620a:1996:b0:7a9:aa6c:f15d with SMTP id
 af79cd13be357-7a9e5f7aeccmr74770785a.58.1726085681232; Wed, 11 Sep 2024
 13:14:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
 <20240911142452.4110190-1-max.kellermann@ionos.com> <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
 <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com>
 <CA+2bHPYYCj1rWyXqdPEVfbKhvueG9+BNXG-6-uQtzpPSD90jiQ@mail.gmail.com> <CAKPOu+9KauLTWWkF+JcY4RXft+pyhCGnC0giyd82K35oJ2FraA@mail.gmail.com>
In-Reply-To: <CAKPOu+9KauLTWWkF+JcY4RXft+pyhCGnC0giyd82K35oJ2FraA@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Wed, 11 Sep 2024 16:14:14 -0400
Message-ID: <CA+2bHPbMwsg8NkvW=FCSwCs9p2B0wBkrfW6AbPj+SOWNHAD45w@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 3:21=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Wed, Sep 11, 2024 at 8:04=E2=80=AFPM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
> > CephFS has many components that are cooperatively maintained by the
> > MDS **and** the clients; i.e. the clients are trusted to follow the
> > protocols and restrictions in the file system. For example,
> > capabilities grant a client read/write permissions on an inode but a
> > client could easily just open any file and write to it at will. There
> > is no barrier preventing that misbehavior.
>
> To me, that sounds like you confirm my assumption on how Ceph works -
> both file permissions and quotas. As a superuser (CAP_DAC_OVERRIDE), I
> can write arbitrary files, and just as well CAP_SYS_RESOURCE should
> allow me to exceed quotas - that's how both capabilities are
> documented.
>
> > Having root on a client does not extend to arbitrary superuser
> > permissions on the distributed file system. Down that path lies chaos
> > and inconsistency.
>
> Fine for me - I'll keep my patch in our kernel fork (because we need
> the feature), together with the other Ceph patches that were rejected.

If you want to upstream this, the appropriate change would go in
ceph.git as a new cephx capability (not cephfs capability) for the
"mds" auth cap that would allow a client with root (or
CAP_SYS_RESOURCE) to bypass quotas. I would support merging such a
patch (and the corresponding userspace / kernel client changes).

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


