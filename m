Return-Path: <ceph-devel+bounces-1805-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E3B975650
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 17:01:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F75C1F23201
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 15:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD22183CC1;
	Wed, 11 Sep 2024 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I80TCJNu"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E7E14EC46
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726066911; cv=none; b=BQidSxsoZlu5+4zT+8cTgzKfw/MvIkpLrszlx1gxGY7bS9+VhRltlW2VxnI2dCjNS/tDYPWdq4gVU+TYA8Fdn8s7SEvsC0xVysRRay8XvW+/7gY2wNlEMb7Z+9EgcduPLmw8j+8y//EqEiE7hOoy1DKmhyKRkdqt2hNgmboGi98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726066911; c=relaxed/simple;
	bh=+bp5jNkh0sEpte3fgI8NNHJYPlPV3FQgO3dhcAnwtFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tlG/Yiro6WxCVPG98KamlXgH51/P7ou1U1lKeiX0fYc8ybgBxMBHp21p3Kw0s85n+9darF8/OIohSNgtxajUDifnxm5BYeiWgHtDBg+1luHwhZvdHLJ9FQGACH73+uyLhR+/6XIe0KWrT9IkZNZsinObXmyIGxPSIVup23dPBrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I80TCJNu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726066908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XLn0JUXSczicvUoPLN4Wwhocrdq3XTVqmB3xoJcwWj8=;
	b=I80TCJNuWJEz3o3D0kdoipYg1rKVs+8BQVLnwuHERYwGX7015jthl3Eynpe0swcAISIZ1z
	pwc3ZwC7WTxLsOBbrB3XF6rpLMdTczj8EqoHhVuDxZhg3ZCdKBQWqM6aWWoghidiAy0TYo
	fGyfjpcwk7YdJ1b/X4utd8BlIXhiGYI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-ueLcOWylPZSjGQMPVHeKdA-1; Wed, 11 Sep 2024 11:01:47 -0400
X-MC-Unique: ueLcOWylPZSjGQMPVHeKdA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a1d0b29198so1200458185a.2
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 08:01:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726066906; x=1726671706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XLn0JUXSczicvUoPLN4Wwhocrdq3XTVqmB3xoJcwWj8=;
        b=Uk1q1HBaJUq8+4d6GZQ8+yKeNvqduggw2vHkG226uELDNEGlizvFRGA0MtGaZSqAyZ
         p6gzaxfAKl7E/POrBdC7IYYAQM5hO4UgvgBCYdECqLxQYHccTeWoU7vd+CQj8VSYPOG6
         BJoKwhipXYL2vl24/pa1a45DYBf+By9dqqaxwmO0Hh7kpTcDSjJKOZY9kFi4n8MqwnEe
         Ooh6qjPjPM5NNJTrVKqcfxJ20c0UfDIDP8DHkUhws4Ty4arMBGi/d5O5zkXBd43hIPo+
         LaPfXWh9/oYLfB0EmOmTxbM3v9Ier3Tg5f+9aV1hRcggc8knyGgs889DIc8q+NCbpxol
         Krsw==
X-Forwarded-Encrypted: i=1; AJvYcCUZfO2KYfIn1HznvrHVgsQYaGtl8S4HGvHnyoMwdp9w+vXkoliQhu/xha9/2QJVotxR5Es+K1iWsDnp@vger.kernel.org
X-Gm-Message-State: AOJu0YwcTYGkQGwIjFj1ZMw5Cgv1M698zk4vCPh81RTjMHFqb6SrHvqZ
	LcIieA3Ifb15gv1CKG+I3cEZY13fqUxQGZ4isG1go4M8RVGRXcI1EU7GIqqGTYUqeTgQffWLNrj
	9BZQBjzZnrzUWl+8My0qJ+6RuhlbofFTnk/qPy0mBS9ZSnwewCJY19mexLoGZLaKnQF8kv5T5rq
	/MvPO5wemvRjYQFj6Y3x819xcETrV+QygaHg==
X-Received: by 2002:a05:620a:2684:b0:7a9:ae1e:1055 with SMTP id af79cd13be357-7a9ae1e152emr2103323785a.59.1726066905872;
        Wed, 11 Sep 2024 08:01:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFedvQbeyWCbGq4+lmTuZLTMZSDQlJ/N0BLS/JVsMA7jBX7rrmuZduSfmR81ZzO0kQDC5jyKKHGNRi+hVI7kfM=
X-Received: by 2002:a05:620a:2684:b0:7a9:ae1e:1055 with SMTP id
 af79cd13be357-7a9ae1e152emr2103319685a.59.1726066905506; Wed, 11 Sep 2024
 08:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com> <20240911142452.4110190-1-max.kellermann@ionos.com>
In-Reply-To: <20240911142452.4110190-1-max.kellermann@ionos.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Wed, 11 Sep 2024 11:01:18 -0400
Message-ID: <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 10:25=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> CAP_SYS_RESOURCE allows users to "override disk quota limits".  Most
> filesystems have a CAP_SYS_RESOURCE check in all quota check code
> paths, but Ceph currently does not.  This patch implements the
> feature.

Just because the client cooperatively maintains the quota limits with
the MDS does not mean it can override the quota in a distributed
system.

NAK

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


