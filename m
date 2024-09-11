Return-Path: <ceph-devel+bounces-1808-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2689C975ACD
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 21:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 593E41C22561
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 19:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A4B1BA28F;
	Wed, 11 Sep 2024 19:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="hX8CLF9P"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D301A01C6
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 19:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726082497; cv=none; b=WWJJ233Qe+LmOaGuEL3qkXCBkGoBTK81SIsuJtnKDPB0r0W2g5WYmavFKIklboSps+kxq8fgpQGfjaFWCZNW0McxjnBZFeqEoGC6GZcdGrvOWJo5lWuGRZAOWHFabzEW9V6UyouvM7rHyCa1vEaslCJPoyGfMxTpbxRNFWOlS6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726082497; c=relaxed/simple;
	bh=GZkVq4TBqrn3vMbqIqMSCkfD9fGneTIINko7V6KeZs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uOqikS0DIcsaw5ut9DDWNLISR8OfzISEy1zA58/jfTpXdsg5Ljb/Tv/Uq2sTJ+gFFo1sKABzsVQqpngZi2+VCcRa7YC619rQ6dSpnKxHJOjiamt707rSIc+iTjA5orpHFS8yxQS12n+wPPp7Bi+roL5fWGd5BvlacJob8qVCnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=hX8CLF9P; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8d64b27c45so25996166b.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 12:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1726082493; x=1726687293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZkVq4TBqrn3vMbqIqMSCkfD9fGneTIINko7V6KeZs0=;
        b=hX8CLF9PrIsTVT7/EY9yUfSQJ8j/gpmsJ6uUTD0VNlMaDcS5ejr7qx5cQG/8owITO8
         j1nEJgpvZZROQJf1elhbRjeD76njgiDtxBVHb57XoRrPh2oHvc+c727iGoL4L+ll8k/c
         S7lC59ImBIMdSsbI6YJIXj/DOMHVj/5cr5c2ihraEeq9iuhx4/RtPGcfFKTdVpzU0NA9
         lrFiA9qDBrKeoXepoxJBneOEbMFVQ6hXiFPhwgxME7Fs5cG+XbfYNfN1W0OZXbocvxfi
         RIuNwQTgcFvlG/nWs3MwoMckoATUT+9XWPng8TvUT5RJU7W1JQzKbRD9WZW7T7mIDRCe
         Sz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726082493; x=1726687293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZkVq4TBqrn3vMbqIqMSCkfD9fGneTIINko7V6KeZs0=;
        b=nqo2NgkvwJ8FhLvs2Dc3/XA2ApHSjDmPsqON+pa82CnUBnnVFeIvybOXUVePulq/5q
         kxH3/6xEL6KSo7q3N3shxsPxbuRAI8nl7qtDksLHEUBMhJylnK/vDMY2Bte10Qb1TTlA
         iJb8JmhviR++B2OjaMKN7cdZWWHFRyGGZ1PJvP8Sndg8ijL99Msp2PsgNaDc2tvAk6q0
         shwcqnia2txkxBYdaZja+uSKhWtyPVbTD/1GaK85GEbIFhIUYtiQmoE6ui0K8kopWFbV
         JGIK0kIsVfQvjbBo0NvfzNbFXPg0KQTpgPqRE8Ps8stasvE/O1pMvWT3NF4ZOm3C+Q42
         AFKg==
X-Forwarded-Encrypted: i=1; AJvYcCVKD3QtLZ/hSbemL49GvRmPJn3xqDkqnkkcCa/GdrLfxeEovRP7lnZ3uI/UPGUzx6qZojxyAEgCh4qU@vger.kernel.org
X-Gm-Message-State: AOJu0YzAmAubcTaANcktlzUwxWVgiTvJ9BIl6VzGA4Jipw1bLZfi8ePM
	bUFMAFXnb6DrqHhJgLpXY3QJnB8LVmxRR2nmPOO4e0ChStP9ttNs86Mz6RfGST5Aug4v7TuzdOD
	9EX7uzo9f00zYNfAPMH+4tyLpPgylxa+X8p9EIQ==
X-Google-Smtp-Source: AGHT+IGzFkoxRAHMAoSH1PCF8jW9WMpjUkdd3qdBFLUhwQLg2F5i8kGcbwBoRGpJWxVgkhg44hDv6+r/xdUPJPB2OjE=
X-Received: by 2002:a17:907:f760:b0:a8d:5472:b56c with SMTP id
 a640c23a62f3a-a90294644d7mr48584766b.22.1726082492905; Wed, 11 Sep 2024
 12:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
 <20240911142452.4110190-1-max.kellermann@ionos.com> <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
 <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com> <CA+2bHPYYCj1rWyXqdPEVfbKhvueG9+BNXG-6-uQtzpPSD90jiQ@mail.gmail.com>
In-Reply-To: <CA+2bHPYYCj1rWyXqdPEVfbKhvueG9+BNXG-6-uQtzpPSD90jiQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 11 Sep 2024 21:21:22 +0200
Message-ID: <CAKPOu+9KauLTWWkF+JcY4RXft+pyhCGnC0giyd82K35oJ2FraA@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 8:04=E2=80=AFPM Patrick Donnelly <pdonnell@redhat.c=
om> wrote:
> CephFS has many components that are cooperatively maintained by the
> MDS **and** the clients; i.e. the clients are trusted to follow the
> protocols and restrictions in the file system. For example,
> capabilities grant a client read/write permissions on an inode but a
> client could easily just open any file and write to it at will. There
> is no barrier preventing that misbehavior.

To me, that sounds like you confirm my assumption on how Ceph works -
both file permissions and quotas. As a superuser (CAP_DAC_OVERRIDE), I
can write arbitrary files, and just as well CAP_SYS_RESOURCE should
allow me to exceed quotas - that's how both capabilities are
documented.

> Having root on a client does not extend to arbitrary superuser
> permissions on the distributed file system. Down that path lies chaos
> and inconsistency.

Fine for me - I'll keep my patch in our kernel fork (because we need
the feature), together with the other Ceph patches that were rejected.

Max

