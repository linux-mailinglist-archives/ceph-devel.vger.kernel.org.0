Return-Path: <ceph-devel+bounces-1806-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A53F9756E8
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 17:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 189481F22CC1
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 15:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99EB1AB536;
	Wed, 11 Sep 2024 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="fj3W9Whh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685B19EEB4
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068209; cv=none; b=VWK2WpJLwwezKxpPiKxcOF6/6j0oI2Wcx0dbiRg7oLKOJbPftSLEmTz30LqmG5B+umdZ+TxgsstG98CPuckY+k8sIyb3WQ3+wldnjgEizNYunQcVIdXSQKrFS28K/20A7Vhx+9EcWLQc1pEAj+sV0pjxpWWmvhwcJ/zxuIpVP1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068209; c=relaxed/simple;
	bh=yEPIVWHJksNfAyZJoUCmfdgswGdbRYfUnspCXGCDCzQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A9a/YmmipwXIynPFo9faJM+eYw1uD66tpjBIzi/XzHKNhduQPaGQ0NIqkUv5Jed4cUSw3EpSZ8cFi3oCq/uHjbJ/s6HcYBkyY7nsQPIdFEBdMTpkTxJ+xCbaWVrkItbQBX+cnj97VBvITbt4JcEzymPYtatt5M76I82OWfyF75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=fj3W9Whh; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a8d0d0aea3cso698094666b.3
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 08:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1726068206; x=1726673006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEPIVWHJksNfAyZJoUCmfdgswGdbRYfUnspCXGCDCzQ=;
        b=fj3W9WhhuQ18wLNZ3h3db1D3O4Rl9rtMKdU/kPGO8mffEBx9Lwi0dSEhpnlhNG6yA0
         uXR8w72PWx8B6+Z2JEiVxOP+8SXP9Bj0JfjoIB+RIa1bNfwg06V57L0LP/KFIv+KoRVB
         fy3NGi95tD0yOPVlBCzXgYPdP4p+BRZ23YQdw+IGJTUKBhYtFwXwRe9E0gH6dh1kAYp9
         lA9zctTL7tBoWZOvF9x3Qvza8hIMjO7YmP1CXfbqyZvQWEEQXW02strt28jA84RzdHl9
         phpp655THdveQGZln1LDZ3qrRjTqgUlCRnphthczVEdYnGYX0w9z4RbpUh64wdcepAG0
         snSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068206; x=1726673006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEPIVWHJksNfAyZJoUCmfdgswGdbRYfUnspCXGCDCzQ=;
        b=dyh1grw2JhQznPYPLnzqRTutYdQmpYbjz1Hg21ZKvIAmRQn3T5SRR/+Drpi/VktLtc
         SA+IPyzF3KnqFXn127PaRQqqQsUzi5oyxpO6nPxU7fkxZS4a3hhS9kaHeknCbZiZANDI
         sFEdHuhTOWhYtji43Iqy0AWjcLWWlkbQdmVTJxI+XKDB1927ee2sFuHbwRcDmVVFuUVp
         u14jgect4etyyrKGNMeDRGkg2/ES0A/nSmhxEdY5gcmTTSzbtJoRx1CP9pGYAxitraXV
         xpSEYCBDtybxDoRfndQt0Nzy5OkERU9JmjQYbSGktKHNlfnJDv8FIVypuSSFOplIe5do
         nkHA==
X-Forwarded-Encrypted: i=1; AJvYcCVZ/A85oUzsTytElpIOsYXc29z4ZiWjIMsjEIjgBROX5xbA3Wuu56N4O/7DjLfHzuHAB3fwgUDPYv9g@vger.kernel.org
X-Gm-Message-State: AOJu0YzE+pk6IHQTSJezSp7vzvbiMQgN0u//6rCCtTBSUNZgEoQaciqe
	xqLNcLiT3+BY0xeAnQoDoY/aaRJHE6jeHHiS0a9mG7OtzkzREGkAjB8GXGUKKjncYgeDXs8lKVp
	t43Bd8DcNJ+FwMSugQb2UAPKzNnjsUP7FPbCcsJtLxlQ0AR0Y
X-Google-Smtp-Source: AGHT+IG3YArllaY/GK0GZj4baDciccbr8DI6d5miMc1e+2B2NMRo4xv6Kl8dn2rxcEBTUrtsc8XXDrjnLLV0jQ5GXXo=
X-Received: by 2002:a17:907:6eaa:b0:a80:f6a0:9c3c with SMTP id
 a640c23a62f3a-a8ffa838d8cmr470205066b.0.1726068205386; Wed, 11 Sep 2024
 08:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
 <20240911142452.4110190-1-max.kellermann@ionos.com> <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
In-Reply-To: <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 11 Sep 2024 17:23:14 +0200
Message-ID: <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 5:03=E2=80=AFPM Patrick Donnelly <pdonnell@redhat.c=
om> wrote:
> Just because the client cooperatively maintains the quota limits with
> the MDS does not mean it can override the quota in a distributed
> system.

I thought Ceph's quotas were implemented only on the client, just like
file permissions. Is that not correct? Is there an additional
server-side quota check? In my tests, I never saw one; it looked like
I could write arbitrary amounts of data with my patch.

Max

