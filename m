Return-Path: <ceph-devel+bounces-2323-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 749609ED3FE
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 18:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4289A1889088
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 17:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D0011FF1D4;
	Wed, 11 Dec 2024 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=raspberrypi.com header.i=@raspberrypi.com header.b="iJ1Rv1gP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CA41FF5E9
	for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733939214; cv=none; b=N9p3zAFf6LsW+RDo/ohirZku8VX9xKi3CNuD5LQD79PNK+Q3K+z6+65ra5X5N+nn4agNgW0B4WwV7pdp8tOW3midMlcLXiLkRSGTZGjTC8oURuK2C4dasdxbNaykByMSVbWMRvRCs3xnl1uzk3yh/Ylpi01SBDrPy2Xlr83EbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733939214; c=relaxed/simple;
	bh=xKfttj73jG1uTZpJNN82RMi2jpdXNIkxOf7nv7eMMZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sYtcC1u2ezzW8uBXa/vkH6VoHKvu/RXi0tNZ3SMGYikXzB+tuuUbxIg5/PLKhggGEb18KFNwyeZ0NluJm6dNo4DiP7QFNqE4+45+OLZS05G6FTFkZoyaEkJrhzVR7VkPyQUfdc2e0CKDZIZQPp8fVpehbeJFDQhcrIrcoBQPc50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com; spf=pass smtp.mailfrom=raspberrypi.com; dkim=pass (2048-bit key) header.d=raspberrypi.com header.i=@raspberrypi.com header.b=iJ1Rv1gP; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=raspberrypi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raspberrypi.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e39fb8548e2so5649793276.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 09:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google; t=1733939211; x=1734544011; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XX4yF9JMGXX3II/VI0ICz4h+LN+8Yz44eu6TfJ04Ugk=;
        b=iJ1Rv1gPyVXZinfE2j1hskrQVtwOTmifZx892vfPVXmW+A4luks2PdH2B2Tl4HOqN6
         U9LqS7pYhhesWy/EGPUEEaXNixUTWci5GU5iiVALQSIcaGNrrwa3KRwiY7NIu2Xm5M9O
         b3bR1JInOlALvNN3xwW/FiAhOLXRWEdfW4VOahL/Xlyp3XRxMh8RsYIj5yDvN6DZJ7Ul
         iOh4z0HBbsY9FYf1yBBSENjuPtqUFQzg036S66WXVQnVehFi4bWC3djajWjWbKhxsi1b
         JZ7nHrGpMISaEuXqGNuZ52zlgMmrRhLWgeS7Sg8Hjg+/P5uGHHslF0Tnhj90FCLu3x1z
         uF0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733939211; x=1734544011;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XX4yF9JMGXX3II/VI0ICz4h+LN+8Yz44eu6TfJ04Ugk=;
        b=m8t3HorfNxMOeOcEpQnW8VgLKLi8lKvRPcJM3P/kMUq9X8hj1FG0+bTiRcz/30oHXS
         QMJYk+eJqXaUZJqJOhTpg5xJBHbndGdREjshKG9oQ4o2bEyopo7/Egtz/Vyluy5Lf5fl
         2L3fBwzTNv4NfDVQ+TENbV/Bkb0Kfj4MbWDAiLM1SXg40vjG3CJuT4YyE3s+8qFiL2pz
         78mL053Jd/aYVkzUw+uXSA8XzRA8c+Z+2AhWUspy3/r6rfbaTnVYPw8wkXovazK32m9r
         FtLVlONBqSChOUO4t6+BKXKULi/JKUTan3OVQ9JARba0UkZNTT0P6NT0tDQOE4eKrCRF
         2Cmg==
X-Forwarded-Encrypted: i=1; AJvYcCWEe59gEDDaYP0dggmug59wAT0+5d68Hjdu/Ugx1IdfzzqZOzZSJAhcXCfWtTPU1JeL+v3Od0MLtxNo@vger.kernel.org
X-Gm-Message-State: AOJu0YybyJjwtN5Ft+GbG8qWW98O9uImFk6Y7yVDpagdO7aZ5gVD7rw1
	5gMEsEaH2ZzNa4SlopS71+Xa3hO5CSQLg3RWa2tFdJGjAH+QoJyaXm2mw1VZVfWsCoFq/DpH3xC
	ifc4/VbKPzQv9F0TOWmMRMhTRi5qRQQ8C3Ritkw==
X-Gm-Gg: ASbGnctlQkuws27GEC9lEckn1DMPs8QDcmDkQh2N1iCGMRaszaOl5y4/sawvPADJHaW
	ANTkWtpF5CfGlB3aF2+xpxu5cactuwRW/NJI=
X-Google-Smtp-Source: AGHT+IG3lDp6pcc8WpN9DOxtNpymp29steFnShZFR78LeXrDU2v7lqz7zSz8oGrhbnT8m3jrCYcj2LxsZTVFVNmSQds=
X-Received: by 2002:a05:6902:230d:b0:e39:8a36:5771 with SMTP id
 3f1490d57ef6-e3da3158089mr228005276.34.1733939211006; Wed, 11 Dec 2024
 09:46:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
 <20241210-converge-secs-to-jiffies-v3-16-ddfefd7e9f2a@linux.microsoft.com>
In-Reply-To: <20241210-converge-secs-to-jiffies-v3-16-ddfefd7e9f2a@linux.microsoft.com>
From: Dave Stevenson <dave.stevenson@raspberrypi.com>
Date: Wed, 11 Dec 2024 17:46:32 +0000
Message-ID: <CAPY8ntDHcGpsaNytY2up_54e03twqZ2fj1=JTnb8x7LLo3uGDQ@mail.gmail.com>
Subject: Re: [PATCH v3 16/19] staging: vc04_services: Convert timeouts to secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
	Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, 
	Robert Jarzmik <robert.jarzmik@free.fr>, Russell King <linux@armlinux.org.uk>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ofir Bitton <obitton@habana.ai>, 
	Oded Gabbay <ogabbay@kernel.org>, Lucas De Marchi <lucas.demarchi@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, 
	Shailend Chand <shailend@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
	Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>, Jeff Johnson <jjohnson@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Marcel Holtmann <marcel@holtmann.org>, 
	Johan Hedberg <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Ray Jui <rjui@broadcom.com>, 
	Scott Branden <sbranden@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Louis Peens <louis.peens@corigine.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-scsi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-block@vger.kernel.org, 
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
	linux-mm@kvack.org, linux-bluetooth@vger.kernel.org, 
	linux-staging@lists.linux.dev, linux-rpi-kernel@lists.infradead.org, 
	ceph-devel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-sound@vger.kernel.org, oss-drivers@corigine.com, 
	linuxppc-dev@lists.ozlabs.org, Anna-Maria Behnsen <anna-maria@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Dec 2024 at 22:02, Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies(). As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.
>
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
>
> @@ constant C; @@
>
> - msecs_to_jiffies(C * 1000)
> + secs_to_jiffies(C)
>
> @@ constant C; @@
>
> - msecs_to_jiffies(C * MSEC_PER_SEC)
> + secs_to_jiffies(C)
>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>

> ---
>  drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
> index dc0d715ed97078ad0f0a41db78428db4f4135a76..0dbe76ee557032d7861acfc002cc203ff2e6971d 100644
> --- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
> +++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
> @@ -59,7 +59,7 @@ static int bcm2835_audio_send_msg_locked(struct bcm2835_audio_instance *instance
>
>         if (wait) {
>                 if (!wait_for_completion_timeout(&instance->msg_avail_comp,
> -                                                msecs_to_jiffies(10 * 1000))) {
> +                                                secs_to_jiffies(10))) {
>                         dev_err(instance->dev,
>                                 "vchi message timeout, msg=%d\n", m->type);
>                         return -ETIMEDOUT;
>
> --
> 2.43.0
>

