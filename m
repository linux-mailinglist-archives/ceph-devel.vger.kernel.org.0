Return-Path: <ceph-devel+bounces-1807-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 718D79759E5
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 20:04:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2549C1F23FEA
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2024 18:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F25F1B9B36;
	Wed, 11 Sep 2024 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQ/7/ggF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852231B532B
	for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 18:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726077863; cv=none; b=uPQLTIqp/FLTvbTG61ELfdFiwmXRScKAzdM7yJce8RbgkfJxC/StIVOrU74fQFFUsJNa+kvfFmhJqwxVllrXvPHItkDl4kbjsTmGQeijzO9A65CD6gu5KbAAr2c5Rbhwm6CJ8DJXXi1Dgdmh5iOSvL89KF+1XtEe4n07vVcfRUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726077863; c=relaxed/simple;
	bh=2xOHoF8thTJ3GUjh87u0t/cWagcW7jtsz01Vn56SM+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6e0macQzE91RtAJhADgn63mYodh+ReJfLhWI6zCA/OmyJ/fyEOW6ZWK9nmUZ/SAqazNCf6A32FN3TviwIDciAWKMDBhO1a9N3FONQd4+1aX/PjUPE1sEIGawMgOOdMtGKQeoGhi+pEiikNd8wtOCKGB7vPyO/iEHHz7eCDGqio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BQ/7/ggF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726077860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2xOHoF8thTJ3GUjh87u0t/cWagcW7jtsz01Vn56SM+Y=;
	b=BQ/7/ggFk9Z0VyP+PX19OEf70PtjXDHuT82wAww1IuaFf9RZXb6LIocKvFY8ozFQ9Kfbwk
	85DLE/bh+XVODjUAq5TLksAIurtiaPMaXiaSeIj+WWBmiyqfYTRW/Fa7r9VOScSzFGkpt7
	Qs4oJHc9Nmt3MXolTjiiUIPh8sqJ3PY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-GXaPBeewMKqoaePV2zKk4A-1; Wed, 11 Sep 2024 14:04:16 -0400
X-MC-Unique: GXaPBeewMKqoaePV2zKk4A-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a9a653c6cdso227006485a.0
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2024 11:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726077856; x=1726682656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2xOHoF8thTJ3GUjh87u0t/cWagcW7jtsz01Vn56SM+Y=;
        b=WRl3Nj5WyJMVhWVIN0UMGVKqS1r0OeBJo3Cn4S1ZADs42dv6ZikyX5gZ5jBUB85zw9
         jhD4SPHVbMU+wfUE6N0lQJZCPckINUdTFSzD4o0+kZLXsVs108cF68fkcyj7JppW40ev
         ib29JPuH6uvThQCdvuykmbh+DxxMN+/BWTqfXGcbqYhospNvRJhRXaeJNE6nwX1hpumD
         6jkx0g6ZRptkQNuCbDztZc02sDDDg+PXYH4r04L5jM0GN3kF/1hmnlSjrelS4vpeWm3h
         mhB8UDsNI3QylMAOkC7gIy8+KHl5hWtsjYXZjAjUtwAaoiIDh+2b7vQz73dahZ88IqYl
         F/qA==
X-Forwarded-Encrypted: i=1; AJvYcCWjn206qbg2Or2Gtr2UXzjDwUCws/72UgFirR7imuvV5Ooot7c7ay1SCTFQ3SNvxOGZjAYHY3iF3oWj@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ/Ehy7uLoYPinjgamDCsK7JiqGUU4BkYxa3eJeuQt9+icpZTj
	rUqrXqDSrL2cF9ku88dnlCMEGcFCuMhzjYUzce9PWwDivGl8n6Gucn74IhuQ2fgbH++VE1dfkFn
	TO8pz1KsxfP0Fj/zVHO2YDrPJwiSFSXXv9+f/xdC6Lo+hcb1jddy4lq8WN+iw1okJQlwHpLPX79
	0wfBrQ4xa4PNe0GcTopkLljitInASLvNeqgQ==
X-Received: by 2002:a05:620a:2a08:b0:7a9:b928:5362 with SMTP id af79cd13be357-7a9e60bb946mr33362085a.17.1726077856159;
        Wed, 11 Sep 2024 11:04:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOpsqs+dX0NjYLBNxcVRIIXvqV1z8VwH0tp118Z9B9RFh9BkGtU4S/d/XePBzURIlqO1bNg42AHvijqbUzRcc=
X-Received: by 2002:a05:620a:2a08:b0:7a9:b928:5362 with SMTP id
 af79cd13be357-7a9e60bb946mr33356485a.17.1726077855646; Wed, 11 Sep 2024
 11:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4b6aec51-dc23-4e49-86c5-0496823dfa3c@redhat.com>
 <20240911142452.4110190-1-max.kellermann@ionos.com> <CA+2bHPb+_=1NQQ2RaTzNy155c6+ng+sjbE6-di2-4mqgOK7ysg@mail.gmail.com>
 <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com>
In-Reply-To: <CAKPOu+-Q7c7=EgY3r=vbo5BUYYTuXJzfwwe+XRVAxmjRzMprUQ@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Wed, 11 Sep 2024 14:03:49 -0400
Message-ID: <CA+2bHPYYCj1rWyXqdPEVfbKhvueG9+BNXG-6-uQtzpPSD90jiQ@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/quota: ignore quota with CAP_SYS_RESOURCE
To: Max Kellermann <max.kellermann@ionos.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 11:23=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
>
> On Wed, Sep 11, 2024 at 5:03=E2=80=AFPM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
> > Just because the client cooperatively maintains the quota limits with
> > the MDS does not mean it can override the quota in a distributed
> > system.
>
> I thought Ceph's quotas were implemented only on the client, just like
> file permissions. Is that not correct? Is there an additional
> server-side quota check? In my tests, I never saw one; it looked like
> I could write arbitrary amounts of data with my patch.

CephFS has many components that are cooperatively maintained by the
MDS **and** the clients; i.e. the clients are trusted to follow the
protocols and restrictions in the file system. For example,
capabilities grant a client read/write permissions on an inode but a
client could easily just open any file and write to it at will. There
is no barrier preventing that misbehavior.

Having root on a client does not extend to arbitrary superuser
permissions on the distributed file system. Down that path lies chaos
and inconsistency.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


