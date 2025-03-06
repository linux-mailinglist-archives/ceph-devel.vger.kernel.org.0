Return-Path: <ceph-devel+bounces-2872-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03DC8A54D9C
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 15:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3896416B1C6
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 14:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3FDE1624DB;
	Thu,  6 Mar 2025 14:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qoz/7W5g"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3482B14F9FF
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741271010; cv=none; b=i/SbXJs4CIfLORoDCa8dO5urKF33YHcZiQZcmRWSUn7CHopIkaxnIDdThwz+rgE+tX+Bspo6f9PWUoYSsJZnnkhFZMCB49XngYx4k8ztQMMK9rU5STwiYCryIDPSPUeu35VysNKci1mCY+Ego7aFMwB99Fje92kNE+E+3B/vTRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741271010; c=relaxed/simple;
	bh=4cRnfMrXNgP74AhMUv1DDwM0g0qby4EqWt0I0z8eUz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gwkGDnVu3YuNMwrZJzLGgyXs9Q6MojNdyPIA596aJnV+85mPf5zOsW6bSEhkJpTbMP0TdULfSfu74kMwhriBPWt2lHwOlkN3qMAunnmqkwbTMDCskXzhx9UYRxyTgreIvAkogoA2jiQJaTr8xGphb/BIojLI9jPrsQgtX9bDtWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qoz/7W5g; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741271007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+nfX7BA5sGs6XnEIq4XvE0XeVuE0RvvxaHJszvCt4E=;
	b=Qoz/7W5gH9ASezRYY8lp87UV0bbzqYqumB5+13u0za09IdL/q0QAfelHGHIR1kJJ3vsuS7
	K1k9W4UY1Yickbz1zA3sJWaP0A6OJlNpQ8axC4nWlZ1kaOZffC0GIYVLZgEzj03U5s7Ppx
	6CoZ2S3fhSkuPY1cddUc+hF8pyT4da8=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-ccbHiW4oMRK3F2tKTk2Qmg-1; Thu, 06 Mar 2025 09:23:26 -0500
X-MC-Unique: ccbHiW4oMRK3F2tKTk2Qmg-1
X-Mimecast-MFC-AGG-ID: ccbHiW4oMRK3F2tKTk2Qmg_1741271006
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-523e099a6c2so84524e0c.2
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 06:23:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741271006; x=1741875806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+nfX7BA5sGs6XnEIq4XvE0XeVuE0RvvxaHJszvCt4E=;
        b=h2Wjz3I6nK7ogsPhztw3RHB/LkOGH8rlFceGwN4t8ZV7cZ3k0psIse/rKCZ1m9lXyY
         xf5vUzfqpkmOZUkGBsi6HSk0lMt6lKzuMRn4w60IMUb6Io6fSHEyS/2dSSNa0xA6LoMq
         F3FaIKugDAK8WIi+KpiFxU1B5z4RBFP1GZJNzpbEuZdMGEuzX3mXDZUnddyvxFEEFk3u
         aKVeoEBf4noktGf0r1TXCuTkbRlaPY7QQq0YQb66+YKDrVcxdrVKp+/f5xsTBoyzXRNC
         Ly65sOn/XRGZvfEVH1mvyKMsk24yEsMTq2bxgPaiHpnWt3YUjUIU0BdPSvtNVG4xTv5r
         HX3g==
X-Forwarded-Encrypted: i=1; AJvYcCUPxkESE8dcyPvkW/Gmc6DFeoYHrXyIm8iYuIhF4bO2fUBBdlqy6n/SmJi7s2ye0mysB8HU3XZDmlqn@vger.kernel.org
X-Gm-Message-State: AOJu0YyZdD2MtPeGECW4gXDETPnhlW1+OSS8ELpOb7LkTRPLVq38e5en
	it2vU2OPzHbvTPn9BR5bvI2vFD63XZ/mg3wgm/8OoGLAhzf1f2Bwog6deECehAAFn2JHGOFF7tW
	fbjwf3VNTqRCOqX5tAn/gqfj3BW3Wwvt/1qLlTxWErAnSZMBUgxae1Eb4DXVDRy8oeTraiCUOuH
	9CLLw1Bss79Nap2IvCSYeh0LqEUb86RWy5hA==
X-Gm-Gg: ASbGncvY7dQxo6tkBdxjMbH3tgZPBS0+Mp2N4l0SCMWfvEhg4M467d2HPPLIEUJDA/C
	rHOx7WFGchC3egmkvwQVOpOrjT7HYIkU9KxSmXc6Co/d1dUC/c6q+fjmhKo9YmSSOMaVDfgbd
X-Received: by 2002:a05:6122:3543:b0:523:a88b:a100 with SMTP id 71dfb90a1353d-523c625956dmr4740541e0c.6.1741271006259;
        Thu, 06 Mar 2025 06:23:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVtr9AvTdUbotRfqs+82ZfKfpB2lA9Qt1Ki2tmjlpkAJqqa6nz22ssPNDQkUZJFq++aFAEU6yXyv7SXQ3yJn4=
X-Received: by 2002:a05:6122:3543:b0:523:a88b:a100 with SMTP id
 71dfb90a1353d-523c625956dmr4740524e0c.6.1741271006018; Thu, 06 Mar 2025
 06:23:26 -0800 (PST)
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
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 6 Mar 2025 16:23:15 +0200
X-Gm-Features: AQ5f1Jq_ryt2aasTBoPxa3bwyGoKVzt6gn9_fb4UHa2K0kNZYORUSPftWl9IxOI
Message-ID: <CAO8a2SjLjejmEHFybLJYST4cNf+YyNyCHZKq_5pwsenqkjPrSQ@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Venky Shankar <vshankar@redhat.com>, Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Gregory Farnum <gfarnum@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's best to rely on protocol specific error codes rather than system
error codes in these cases for sure.

I'll make a refactor.

On Thu, Mar 6, 2025 at 4:13=E2=80=AFPM David Howells <dhowells@redhat.com> =
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
>
> David
>


