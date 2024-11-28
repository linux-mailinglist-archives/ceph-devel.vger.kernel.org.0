Return-Path: <ceph-devel+bounces-2211-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA86C9DB7AE
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 13:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA695162FC3
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 12:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C8F19CD1E;
	Thu, 28 Nov 2024 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="YVx9nmKX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195219C54C
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 12:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797102; cv=none; b=RbE/ln9r19PWENir7ZV0l2FG7SHlleUPlz1Bl1QaUq90/xoOZP/dqIYXrRatZbAmsqT9otYB//GBzOZBK2vVL4XOfvQeusfTi0eHBVIGLE+6X6cxDgKEwQ05Jkq9oNxsvtgPkraBz9CDVhreKQoWhH1SN3FZgVv9/eXHKu5SPgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797102; c=relaxed/simple;
	bh=iYQoZNHZYvu4ako70Ag18jWmbu6070AIJp0pvQOIGuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PmgpEJfy1Gf/Dsmukok7dxjiyXlDAExZOJdQiHIxd2Y3nz1tHYfpOcm5AT5eRPk0uXWbnkyWeS1uHSwTEpKn8gxxsrccLYTJxKfRcJhsj9s/VIcH0ZXHa7wifNmZ/nMQDpNiQj+p65lExNf7jHxQ4vAOSqdwNa323lDBRiXMFcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=YVx9nmKX; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa52edbcb63so322691766b.1
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 04:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732797098; x=1733401898; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpoemVatfaaeXNkbkmZa/3Of/FndPg8UClILORZPzNY=;
        b=YVx9nmKX5iw7yTxJzH5RpWay38ZZd0q0aiXI2AstXs61siPVdmOuWZ0vkK2VG+BVIL
         84leBF2jGpbiIPp464ommBg/8xNRjZbSEKgeQ3dpNiZZ9vrhOqnSrN+aMaKWAfq1a+ok
         yXRNIM+4c2SLD4o10mcMqJJvpluM41IuVEuMz1+w7rvWnRIpKloR4eP6Jq4F/Tsp5tff
         ybK/tdJtaoTmbBDDRvHr7Ll87abKyRD3mIxr2Y6pa0WOxmGEpTY2JcCo8TBzdZ3ZvXVA
         wBaq8OQ4coZ5LRlgb1GMdvKCV7ktDdnW8WSQy7tZ4/dXBHAjO/lbit5mYeRHwnkCOwG7
         +Ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797098; x=1733401898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpoemVatfaaeXNkbkmZa/3Of/FndPg8UClILORZPzNY=;
        b=k1OzUQb+AXCohJjrY8S16xeRhn2tIE2UjEugQEtlY06dkMS+GNP/Qc1vayKK7+boIB
         Cz8udvZmDqWqzn0VHQj6BiASUSZ0UtmgpQ5+Zm9bhbIn0TMUKb0luZGxsZbe/Z1fXFrs
         vQan+R6xC0at2yhUhDjkYNy2CqlFIlfAyKRYdIRhTo4FkVB+hGj6SpiBdqztbTNCWc1b
         cEp0B0itAWl7Kr6V+eQ16n4cTC04b44BswyQgNag+IlBoFtSzFgp+55x01Q364e7CZmC
         5BpjbIVNQLPUGjdMQgSmMKxPpP3fexgwzcs0eWLw5oDBoX1p+t9be4tVI76Ev7TugAsI
         AhMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuYrof64haBCWxOG9aTh7+ceXubzF+P+7veVLKQGeTBSq2LRkzxoFQMUIH4JFrH6yKl1heFLnzYVZO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxsr2908/Pwx/EK4+tLyqUa2VQcAmyY0+xvXXOjfCxfvNwNCcZO
	t/9tPzGNkj0I9XQ0mFLuZD8Ot6TrnsthN0Hz5sV5CDVDQr6OClZAjNBgUZzfJfgx+BVgZF9Wnfr
	pRH5uJdKeXv81Ldzvb4RBN3hoV48zchsV/8HNmA==
X-Gm-Gg: ASbGncvAllMIscbaZkiDLf/hB9VY/je8zv+pOyIuOnz6Ryr/k8I8qitQgx9Equd5Wgm
	TzcD4Elci3GfyYS1/dNOnXQDFWtXCYnDA+sefF8V1xagRTrASx60sf+1FgNvV
X-Google-Smtp-Source: AGHT+IG/PJy6jtkMD93q3vrdJc5oVLajZQBh1b3v2P+6oDKVmYlQzPR4JSl6ULCxWrxgGCHo6jToM+TuxfktaXdeQ6s=
X-Received: by 2002:a17:907:7615:b0:aa5:358c:73af with SMTP id
 a640c23a62f3a-aa5945075fdmr348570766b.6.1732797095349; Thu, 28 Nov 2024
 04:31:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com> <CAKPOu+-Xa37qO1oQQtmLbZ34-KHckMmOumpf9n4ewnHr6YyZoQ@mail.gmail.com>
In-Reply-To: <CAKPOu+-Xa37qO1oQQtmLbZ34-KHckMmOumpf9n4ewnHr6YyZoQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Nov 2024 13:31:24 +0100
Message-ID: <CAKPOu+9H+NGa44_p4DDw3H=kWfi-zANN_wb3OtsQScjDGmecyQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 1:28=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Thu, Nov 28, 2024 at 1:18=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> > Pages are freed in `ceph_osdc_put_request`, trying to release them
> > this way will end badly.
>
> I don't get it. If this ends badly, why does the other
> ceph_release_page_vector() call after ceph_osdc_put_request() in that
> function not end badly?

Look at this piece:

        osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
                         offset_in_page(read_off),
                         false, false);

The last parameter is "own_pages". Ownership of these pages is NOT
transferred to the osdc request, therefore ceph_osdc_put_request()
will NOT free them, and this is really a leak bug and my patch fixes
it.

I just saw this piece of code for the first time, I have no idea. What
am I missing?

