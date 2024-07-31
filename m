Return-Path: <ceph-devel+bounces-1623-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D35942D5D
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Jul 2024 13:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6DB11C226F5
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Jul 2024 11:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F331AED20;
	Wed, 31 Jul 2024 11:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="bxLoMOPO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CB71AE845
	for <ceph-devel@vger.kernel.org>; Wed, 31 Jul 2024 11:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722425834; cv=none; b=DbZbc6sPWql6t9FNh9xZjQ8WleuSfNuYjAep/uLSjlAK719QyKu3DPW7st0SfuOuSQJnNBn0AgE30ENwFtq3sjHUDnYvBinNYdBvNu1KGbApcY37flJib7BqQkN73I3mhJbTfUef918hpe6EaAmGljYCwIRVzWVrUcGv6ODEYsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722425834; c=relaxed/simple;
	bh=gmAAodUXdgnNESvRXNAekJJqooqvvUxv3wuMM+/4RoA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mNHyTZidrYpvxns6oAoZoxJIi01xAZ0b3k5JqipQEUk3fR9jaXjMMlORewOJhKW+FE1EJ2npSqIB9sT7aK4eq7kR9V3yKZa380/h3eepmgFBeNrk2GczzZWgEVUuywrQHwNNFzg+iirjWvKxqryUVEKGzOtCaaBYzkljZ2zpRhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=bxLoMOPO; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a7a83a968ddso785720666b.0
        for <ceph-devel@vger.kernel.org>; Wed, 31 Jul 2024 04:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722425831; x=1723030631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iVqiOcI/Lm61Kn6z1In0PhQoNC9BfNgfzLWAbxhDSI=;
        b=bxLoMOPOeudPozRvAPyB7PabtaNkaJp9NcIjy/NUHVUHtZy91XIeOZFdzZEqHTQWgR
         MtUxk5AV7lcG1PbWvNlM5IgjD6iNy1yXFsmlxkuT4AUs1yF5WffguciTZrncOJ4la9TR
         YnI5p6HwgEYW8UjjtNSwuXG2qfKAOMVyQ3/bWbAsiGP8LUIfotLsicQsMs8N9CeyPeti
         ymMXVq94xmEGSpEYKMrQzj1GlB9x9eGADLRR8SxUuZy9RouPx0G15ssbdl4dTK8iEvFt
         QbH8lJT8pSA0UJjyb5oGmX/T5flpOKEkI7sXJzaWW5sh9YXbnhXqil2bD+R6KTzJZtHa
         AcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722425831; x=1723030631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iVqiOcI/Lm61Kn6z1In0PhQoNC9BfNgfzLWAbxhDSI=;
        b=OYnlL8t/CU9DrNm1JKeVEa3sz6biZAudB4H/tbNMbKsmhVvqjcmmtn2aDAFa1aciht
         0nkQrlrhZxIev2pVYPpBs9WbfJUzHTNJ0Ny7AXhnz4m+iD2WL8kO3/lFxEgruC9knLWA
         bx9xunwxSa4EedhmM3YFM+lWqhVI5f45+x28HVr27Cr9AoTCxjJtVMFiv/ckhAlGvLRP
         9vCqkmSdjumgWIlCJol2xou7gHt+mkfhTrT0pIBzvIAtOg0+ScezeCWRfZyNBU+aXrTS
         cmWtMQAI7vU7wPzEvTGDJ8slzjbqnANvYdFcCQtponfaqLGSW+euSwM7eFGIi7L0VnBm
         6H0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmOF+Om6u3XA4snHav/fBy5DonU2EtMqbO/DegfSSU69EjwVLtrxkEvbmBPeaaJQY6DCMy0LrGeTSsm4GKb/EHboHfqm5m1KkF+w==
X-Gm-Message-State: AOJu0Yx4tW2+mv9yXugT14M7wloQlGlm1lwAyCT8bExM1ptnIYsPheT3
	HPtXp5ZJPvr2bED+Ptze1+mG5MFoqbj7ANf38OqvzM9YaqE/gcjhnkVPdlVUYhHba72sGQM1QxI
	xVMg0YDX0eHZfhv6w3FkCdeyEugg3/Pq6pNBOmQ==
X-Google-Smtp-Source: AGHT+IGKzF7L3tGT7YjvoFGJDwdINXnVaS2Vxa/MttoDWTfIP0ZESkvvOTXarzXIGvRKUq2y7x6k6CcvXSEnf4eYun4=
X-Received: by 2002:a17:907:6d1b:b0:a77:e55a:9e8c with SMTP id
 a640c23a62f3a-a7d40128ab4mr796501666b.47.1722425831422; Wed, 31 Jul 2024
 04:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729091532.855688-1-max.kellermann@ionos.com>
 <3575457.1722355300@warthog.procyon.org.uk> <CAKPOu+9_TQx8XaB2gDKzwN-YoN69uKoZGiCDPQjz5fO-2ztdFQ@mail.gmail.com>
 <CAKPOu+-4C7qPrOEe=trhmpqoC-UhCLdHGmeyjzaUymg=k93NEA@mail.gmail.com> <3717298.1722422465@warthog.procyon.org.uk>
In-Reply-To: <3717298.1722422465@warthog.procyon.org.uk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 31 Jul 2024 13:37:00 +0200
Message-ID: <CAKPOu+-4LQM2-Ciro0LbbhVPa+YyHD3BnLL+drmG5Ca-b4wmLg@mail.gmail.com>
Subject: Re: [PATCH] netfs, ceph: Revert "netfs: Remove deprecated use of
 PG_private_2 as a second writeback flag"
To: David Howells <dhowells@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, willy@infradead.org, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2024 at 12:41=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:

> >  ------------[ cut here ]------------
> >  WARNING: CPU: 13 PID: 3621 at fs/ceph/caps.c:3386
> > ceph_put_wrbuffer_cap_refs+0x416/0x500
>
> Is that "WARN_ON_ONCE(ci->i_auth_cap);" for you?

Yes, and that happens because no "capsnap" was found, because the
"snapc" parameter is 0x356 (NETFS_FOLIO_COPY_TO_CACHE); no
snap_context with address 0x356 could be found, of course.

Max

