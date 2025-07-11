Return-Path: <ceph-devel+bounces-3310-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DF1B0236B
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 20:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 262C25A780A
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 18:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B822F271C;
	Fri, 11 Jul 2025 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZORYL9p"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30A12F1FF1
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752257722; cv=none; b=Z2qz85anmSL8AibF4qeQznEMatZnegrL74F63ytKQRCp9xElN9neU6soVshtCcTudLBZ7E/8UjzuIH9lF7t6QXGiRKHGUMczdjEwH/a0tAJC0DvR0iTpvAYOvoSB3S9MBj7fVIbDkVQdEzRVwjPpohIW8hcf9Fvh63pagRMu8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752257722; c=relaxed/simple;
	bh=kt825kEGFh52uMeqSmlhqY8wxHV0EBxe4XLOjEZMQRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceiXOuIF8fCpNMbl6jk9Zur4Oo9P2RWRnHvSJLQunNX6jDuFLYRy603KW+lBdqFhtHAYtdjEwOh7kN6/0YiWY0vWZGJU76fQvKpkQzYdN+kktl+I6J7P2F31VNW64z2SwVBSvFjaYu2JYjKQ/wnvpHXcJ7sGe7e09+JqB82LQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZORYL9p; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b3226307787so2042881a12.1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 11:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752257720; x=1752862520; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiarKAM3yrh+YSC51Q0Vtcojir0OWbIfAbOkLr/z5uo=;
        b=KZORYL9px7k7mMZlV28oSHS4zP6RdgevRwIHnxr2PNtLqzd5TUMx6kpjZixSPouVu6
         YKNNoTnufUWklJgNNUoIPItJrOr38djDWoeHQezmSLiNZ3dPOTMGTWfkn+DEx4p370hq
         Jf1/YK7mSG1QAaCpzjTpgQd8tYGQ2qgVq4G1tWEpwjuz7z8VILoLraoTttVzcA6k+PF3
         IUWqwv7LPpPF0rHqVZ4cyS2yDgMfs5xSl1QpzU746tNrG+wxPCdOL/hfIKnCgziGzD0g
         JkCg59uEDMXPF8f25qn1TobqY0DZS438An131DuTYMET6tvkoKBzBOQ6NINcRHV8RZSe
         b0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752257720; x=1752862520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiarKAM3yrh+YSC51Q0Vtcojir0OWbIfAbOkLr/z5uo=;
        b=f7Rbl4wQku2bMxN9H93VCbCd17C0sjEo1r8sh4c7MeQXnkZWlfULbC/zDSeBGDrcaG
         lse89NWswvorSFMrq/VoaFi3TGBXqDiCe+ZMEqrv2tROllyfc3tUhR9ZvZdgpEFMz0uf
         Ah/7FuiSss6VY8XRkVwujifyn3cRy0GlWzVgyImQTy/PuyxtmR8W/K8oQF2UDBgMihp3
         vyovoAL0bWyh3hEr/cl4pZhrc7WCXsn0/HTyHOLZSoShJQb/gcfPHKViMOnYPFIi5iyx
         dhCraB+VOpa06h8DHEmHEw6WjRXZMK9ZCJzOt4mPx8Q2f7A1PoHXSMAddMA0jGNnytWp
         W5RQ==
X-Gm-Message-State: AOJu0YxxvFIRinGGlxZUN7343WPhoIOrB8kNX65WCauid1AV5dHhpj9D
	2gJgvX9y9jr/Y9flcaP59uNiqgLFpOH/eXnx34Z8HuQWkPbXePUvhz1f7wefoOpRf9Q2TkM81Mc
	5dOWSDCamkXvEvp35uZh9ajFCJAF77nZik73u
X-Gm-Gg: ASbGnct3ticy7BNEVjdoXzAsEHNNUmXx7nJlyXUGsv/+tM15hA3n1Zh674KpWz8ArWa
	GEW422DqP0RAtc2FvgI+TyrcdwJ3P8qC8if1A5nPN2dfGGFg0qRaAVnm63kd+ILw75uC4dE34aR
	pZMqi/qTeOeFQsBHrMrYsQgUoqScIhOWMf8s5y/JrgK6YMcr3tj21ki406Np/rThbYMvEpiyUDz
	U3OnbCnuE6sjD7RmA==
X-Google-Smtp-Source: AGHT+IH0rtyYm0n0KDMP4omM0GNshzET0a2XCtewET7WMl4aYr5M8DnOL9RwWwZIz8jIclikJv6UW/09AWPEJvH0vus=
X-Received: by 2002:a17:90b:4b84:b0:312:f0d0:bb0 with SMTP id
 98e67ed59e1d1-31c4f4b8228mr5300366a91.12.1752257719817; Fri, 11 Jul 2025
 11:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
In-Reply-To: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 11 Jul 2025 20:15:08 +0200
X-Gm-Features: Ac12FXyegygFOpHsKUjZD8_hpKg0CDn63Tf_03qkk6kyTtT7D4nDafwJxSL8Huw
Message-ID: <CAOi1vP__siTd_4g6ZDO0NYDGLjh3wopo-+WK5PDDLvBhwooEyQ@mail.gmail.com>
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2025 at 5:02=E2=80=AFPM Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
>
> Hi,
>
> I tried to discard an RBD device by `blkdiscard -o 1K -l 64K
> <devpath>`. It filled zero from 1K to 4K and didn't
> touch other data. In addition, it didn't return any errors. IIUC, the
> expected behavior
> is "discarding specified region with no error" or "returning an error
> with any side effects".

Hi Satoru,

No, that is incorrect.  The device is free to effect discard on
a smaller range than requested (if the request is misaligned or for any
other reason) or ignore a given discard request completely.  Neither of
these scenarios is required to generate an error.

Further, the range that does get discarded isn't guaranteed to
return zeroes.  This capability could be advertised in the past via
discard_zeroes_data attribute in sysfs, but it was found to do more
harm than good because discard and zeroout are semantically two very
different operations.  Note the change in the definition of that
attribute from 2017:

 What:          /sys/block/<disk>/queue/discard_zeroes_data
 Date:          May 2011
 Contact:       Martin K. Petersen <martin.petersen@oracle.com>
 Description:
-               Devices that support discard functionality may return
-               stale or random data when a previously discarded block
-               is read back. This can cause problems if the filesystem
-               expects discarded blocks to be explicitly cleared. If a
-               device reports that it deterministically returns zeroes
-               when a discarded area is read the discard_zeroes_data
-               parameter will be set to one. Otherwise it will be 0 and
-               the result of reading a discarded area is undefined.
+               Will always return 0.  Don't rely on any specific behavior
+               for discards, and don't read this file.

This isn't really specific to RBD.  If you want to efficiently zero
a given range, use BLKZEROOUT (pass -z to blkdiscard command).

Thanks,

                Ilya

