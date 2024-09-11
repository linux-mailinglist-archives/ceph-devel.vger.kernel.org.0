Return-Path: <ceph-devel+bounces-1810-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4456975C26
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 23:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D75721C21DAF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 21:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FAD143C49;
	Wed, 11 Sep 2024 21:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSZBnsKM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B53F5337F;
	Wed, 11 Sep 2024 21:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726088613; cv=none; b=FRu/T6/BWo8oTB0AU6F411p95Z97QyESDofMZOn7nrwxccQv/u8MvejBxfAEHoyPpVPUmCQx6+vuQU8ShPQ4t8E6CqndYc+yWQrRjHUluPvPtdpXtT4YgMEB2Rgnytzy7O/YKbNV3Vo1fyGNfgTMqw88m88diK6/m8Wi43qMlSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726088613; c=relaxed/simple;
	bh=x4kYaHrE8sbhy5cyW0UJzk1xEqFWZTCCokmAmYiXtqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o3qUoh8qGvwLBgd2NmXfWmZmeVuNsYxAU8u+AP1RsuNBmHoq7Wqm+MEva/MC/Zz/KoqGJIt+kCHamiilR2soYAuNfVev9QQC31xRy6z2B4h69Ve4j2zByaZ9ZExzF2D2G7ii7j4BsWhvlXBIas9Sx91pguo3e7OVA6EyIXNoQgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSZBnsKM; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-710f44f8cc9so623027a34.1;
        Wed, 11 Sep 2024 14:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726088611; x=1726693411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wRQk2obbufrJEOpJfHdMrcKpP03Na2FXN/AS2wAtn7o=;
        b=OSZBnsKMYMDF/02TmzwXcik5WnmI0OWf0gflQo9vKnMlE33u/gJZrpUtg7AQqGDj2r
         Qe7xjajSCcwIZsHc4R67uaOohbMzW14ae0xUWBs6dQrBtuePJ05j2xo72PWvcGIxueD4
         Gmt/ceOlObKlk9p/hLGTHy6jeJd3qKNodc95tDmEYPUURSyWJfZmKPLWJ7Xxjm0BoDSg
         pQfwKH0n+a3xQw9k8FWeW2zO3a22d3bcPih7AXYfVg89yeIBLxTehNhcrERpSPqXLFPO
         YrrJ4gioiSbJA9QWhWVWm3T91CvtLGo8AJDERkfnkYGxAGFViTZdvVh1ntW33LzIwwqv
         apTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726088611; x=1726693411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wRQk2obbufrJEOpJfHdMrcKpP03Na2FXN/AS2wAtn7o=;
        b=ND6yQFYWDQeoOZ80kFZgj1P04X2yRgJBfAdXestll0sncqb+Fw5JSBTGAsnLX93WAH
         TmHXfCosvJNvpeHDfeWJh+Laa3/waTuDUIUGIPLI5S69K1glNovazVj9uBif8Dk0j7Io
         NJwwco7lWjQlIwaum4yeDHnkb8IK9NgghJtP8tktdf7WOm2VdbrHY4wtfnfc9Nbqyd4e
         CMFynKsx+iOkAnoUcMRLGKlraU1pg3UeXzxBzSOqTlGZCyacXFRFvYQuO543kUT/29is
         +J+MPNfNZSnPzV+GIU4xoTV/LktKdIbs474MadEUF0CEX0O27El0yLzChi7KQtfv1Elw
         aX0g==
X-Forwarded-Encrypted: i=1; AJvYcCVPOBsxr43hU5V123lSfg0Cz+cGO0l+aLX7j80Zk3C0DroX4BGpj3FndK1g9+/7BWMxgIbt5wncqq+b9MoM@vger.kernel.org, AJvYcCWvKe1OevGpeNo6OFiGe4xQVsnFbAp/lNw7kZr17MXtjDONskAhHmD2SwABBv4h2pZrJrKT48ZwE0N1@vger.kernel.org
X-Gm-Message-State: AOJu0YxcURvYbr9J+FxAdJJMb7acXCDitvMMC1YtzBYsGRX1q/jF6ymQ
	TTsxOOJBs0xffdkk7HcJzmAXKE6xf6ze3bbnbUSX5A/HqMgnTAq5QQcLZS3vh7SnLiuS9Myshud
	qr0kAhDZolIYOFU5P2OxRNY9LHqE=
X-Google-Smtp-Source: AGHT+IF/aEgRw1SdfgWbqidC9DJANgSt7u8eqmXW3xcdFqMhOcLzNkfhKjWQoVnfManB79Je4OWGQTJMolR32giV4Ko=
X-Received: by 2002:a05:6870:b622:b0:27b:a693:fa11 with SMTP id
 586e51a60fabf-27be6ddea91mr3446138fac.19.1726088610971; Wed, 11 Sep 2024
 14:03:30 -0700 (PDT)
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
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 11 Sep 2024 23:03:19 +0200
Message-ID: <CAOi1vP9CgJnw4ewtewBOb-mjAGvCP+6upW8J61GixQD=junV0Q@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 9:21=E2=80=AFPM Max Kellermann <max.kellermann@iono=
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

Hi Max,

I think Patrick is actually saying the reverse: having root or other
_local_ user privileges on a particular node shouldn't subvert the
CephFS caps system because there might be many other users involved.
If you have a CephFS client that hasn't been tampered with, coming in
with CAP_DAC_OVERRIDE wouldn't allow you to write to an arbitrary file
directly or even buffer data for that file in memory unless the MDS
grants the cap/permission.

However a rigged CephFS client could absolutely do that.  It could
ignore those parts of the MDS protocol or bypass the MDS entirely and
interact only with OSDs.  The only thing that could stand in the way of
a client like that is CephX, which is where I believe the suggestion to
implement the quota override as a new CephX cap is coming from.  If
a particular user is to be allowed to go loose, the system needs to
have a record of that.

Thanks,

                Ilya

