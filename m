Return-Path: <ceph-devel+bounces-2181-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CACA39D23A2
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 11:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D49AB224C1
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 10:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAFEA1BCA0A;
	Tue, 19 Nov 2024 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RTh6gAcU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62311150981;
	Tue, 19 Nov 2024 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732012315; cv=none; b=Eduyjs6EdQNcvce8BoT9MCxRzlOHNmWIr6uDjlDfgK7pH1mJE0FABxXMMY9HzxxXgnw9AxBgoZF5j80lQRoe8vVpuozI1OFapmZejZB3nm7C+IeCnOfKJ4amP3YJkL9QVOmQWEZ2lN2LDkg9T8Xl8V2C2XPxEzFhuU5OQwXkSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732012315; c=relaxed/simple;
	bh=vncP/VW4+/rVe2CURcaP1lHq4HNL3cTjH7m7oLoBXrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=McHiMrNpA+PQCZNsMswopX5GV9e8QDVW5svI/QC40hhIJbusgIuulrSka7JSLQaD82lgPTiZvQ5PQ/0UMvKCYIn4YorliUWzH5pjMkiJ62Pb8EFXzj8OBDOCXs66GVkJDQ+fCzO1OO0U0T+cXX9dXNdmfMzshAmOCkEI88vW3Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RTh6gAcU; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ee51d9ae30so2241761a12.1;
        Tue, 19 Nov 2024 02:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732012314; x=1732617114; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95UwS+prCDlQ2JClARLgsTrSeV6xX5dJozXPtzucYmA=;
        b=RTh6gAcUhDd90k1KNVro6yRFuqrEkFtldEPXkzxuztMqT216HWHtHo+ql/vkdEfmRs
         ravd2MslwScH/zySnQRsoZXR7DfLsczRCNH/HzFBxogV2LYVokaO6ZxGubPoSpYJr0Zl
         GHytIWYttGddAXtbjpkehiPepcN+GUavvQEbm+5BlIpuy8P5rDVHzbJVgmnlPoQT7GxA
         ZrVT0AXzTh9WjmnWCV2hEg/Eqe+UzzD+UW2jrH//Fr1QccFyU8NgUHbHiIApzQ1o8gqM
         XNmm8eOdi4nrw7tMBfOgqhWbahhG5mWNLObYgsFW1dG7GnJ3cedoqzVw4/62eNs+hXLF
         fR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732012314; x=1732617114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=95UwS+prCDlQ2JClARLgsTrSeV6xX5dJozXPtzucYmA=;
        b=GO35NKGywWduq8kIFWcUjoLXMlXSZi7U6AAg6aw5QWQjcGjruVRpDO93cDQEn7DN+H
         o6MOzJAjDtBHUuKVropWJj3qEHsnFmuGIQel3M4kapxq/sqxga1rWoqHkPMhmHl2dFPC
         yLSmVW6wMLzby/Dr62PXElLkaTTny52vOtPIIP4ylV8VHHmxuflPnRNui0YDelXZKQpm
         KHV4nilwtpvyyxUzopC9eztCppGdTRmRYhAQolI+6JRkO4PSs6pa40CmDbIj0adsAGte
         d6dMeXM0Q+dLkPCERSzg9ijnKO4Ne1+zW4oESApjSeYxTOAiN47JbrEp8PX24p0qYh9d
         rgsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVT5dANHCmVpefehTfd6xUNfoiq5lkBz/1UecAezWcf3wvsaNAZpuzX8gaqXeqJ7wHaCWXFvwwmOw7UJY+3@vger.kernel.org, AJvYcCWQYvjM4ZaWx6fzFrBf5++WkqGNb3eqahOg3/0dPfRvigugQ1d/7abH6IK5SnjYOklN1Pj1rdHB8EMq@vger.kernel.org
X-Gm-Message-State: AOJu0YxkN+Wn+S2E/qwDynVpPDATRvrB//uKAVjNjW/O92YRz/Vk7zG7
	vp3Am2vYZiHPsl7MBw794NkA6ucnNPB30FgXT9Ca0e8CyzH7kgs1SXQeFKosUoJFesCkjdQUwqW
	RLsscHCcyGsECRVPIxXgkETnke5M=
X-Google-Smtp-Source: AGHT+IFtzHTIQAmLany1RGllRWkki9LIskWeyoKHz7tFLi2V0/WBQygRHGvyltbv/bnfGyY7bzYYjtig+vQrSAnVHak=
X-Received: by 2002:a05:6a21:32a4:b0:1db:e90a:6b24 with SMTP id
 adf61e73a8af0-1dc90b4bc64mr23852367637.25.1732012313713; Tue, 19 Nov 2024
 02:31:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119022752.1256662-1-batrick@batbytes.com>
In-Reply-To: <20241119022752.1256662-1-batrick@batbytes.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 19 Nov 2024 11:31:42 +0100
Message-ID: <CAOi1vP8Qb0ZL1kYnq0b7-aNkLa560DgCt=0X3MNMSn28kFiWmg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ceph: rename some seq fields to issue_seq
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	"open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)" <ceph-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 3:28=E2=80=AFAM Patrick Donnelly <batrick@batbytes.=
com> wrote:
>
> From: Patrick Donnelly <pdonnell@redhat.com>
>
> This fixes an accidental non-rename change to the caps. Caught by Ilya, t=
hanks!
>
> Patrick Donnelly (3):
>   ceph: correct ceph_mds_cap_item field name
>   ceph: correct ceph_mds_cap_peer field name
>   ceph: improve caps debugging output
>
>  fs/ceph/caps.c               | 47 ++++++++++++++++++------------------
>  fs/ceph/mds_client.c         |  2 +-
>  include/linux/ceph/ceph_fs.h |  4 +--
>  3 files changed, 26 insertions(+), 27 deletions(-)

Applied with minor changelog tweaks.

Thanks,

                Ilya

