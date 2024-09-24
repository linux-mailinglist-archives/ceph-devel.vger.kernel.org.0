Return-Path: <ceph-devel+bounces-1833-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0634B983AC2
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 03:27:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39C782821CF
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2024 01:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD0B184E;
	Tue, 24 Sep 2024 01:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blZZoo1Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496D38C
	for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727141273; cv=none; b=GYq0PHjZsQ0MrDPmnJsqUckEhoEiywsD6bi/o6AOqfJGqmFs9VhIylh+zMD/cNG+FNwGCqSbRGX9BaADRi0A1IJOkua9A1X0J3vRW5DmpP1y0gpHpbbl51MSiab4q61gQqG916TVakv0Z0zt1kO3AzXi8bnB/k5d5EaxqtGjC78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727141273; c=relaxed/simple;
	bh=/NnbR+MJecnDLL+iQMJUx8qlmWlooxGnmCU9yttEQZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JDaLHBixdhyJRvw5CheSk1RMJtmNG1ARfEKNIfI2BKlUHgIA/puU6KQOWIoafQyP/fdOxKrxoVk3m3G5/rnVSwkL4qjajDU1+WGzK1NSRwNin8Ce0PU0SKTxiE3EPkmllVPI5F/pIDJs6V6Qy/h6TpIMYoVMWIrTQxkLTzr9i1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blZZoo1Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727141271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cUpC9psTESlM/gRTGIvgAC0kHgLF9f/HNM+D+J11rmU=;
	b=blZZoo1ZPj93iCh+jkKtDO/LHJkUNkgveEYtWzCQCbQefvysNifFQ/wPYy1WU5w6k7SoQd
	QCpwyRrM/OHlIiWfQnCeCNm1NLPhycfbrkfIWD2klZjpcCT/y8SCIlwAlP72P8Wcb9dvmb
	/LPqIhTV6VAQOqpCiAiufUoUe7ZHB7w=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-Kw6lvrc6PyWERt7O0UvLyA-1; Mon, 23 Sep 2024 21:27:49 -0400
X-MC-Unique: Kw6lvrc6PyWERt7O0UvLyA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4584d6cb55eso118432741cf.3
        for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2024 18:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727141269; x=1727746069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUpC9psTESlM/gRTGIvgAC0kHgLF9f/HNM+D+J11rmU=;
        b=rfiKMJDUTTzrab6PsPjjRcMzWYWWhoENhJ5JxrgrxbuSQ2NDghoPPcCe6qRTUx18ae
         RxbKoLAARwZuNZNhr6mZKRvC7qWL2K1K++wAl1xeYrRU0zO3eagJQc16z59wM9FkkJ4J
         yeH3LeKgYYJ6wBH/9/K2Sb+gDr0r+eLjSWuk+UGC+uOumkl5UAzJ3otLdymdFuPntmtC
         INuvaZQ4aEMJVtfALo6FfGJLv2LnKBs4KGOljZcI0wlnypj+g85uHDeQ0JhIFjysiv4j
         bE2JcW+QjFMUZiAObCv2k8dQeU+VhCMhf6eh21Zbje5tt+RmpbQiIhNn5mLwI4AwL7Wt
         d03g==
X-Gm-Message-State: AOJu0YykxD/o8G9zxMNKvckivXw1kRybyn053ZmgftyW15y6orLibchD
	UqPZ4+3z1WaCt2xZSklo+Ubi36Cy6ipuC881U85B9ovvSoX02R3f871cvfhfIYqMvPJ+1tafU0M
	qyYB+i6neyEH/29BmemfEz3CpeFFIy/NfKx7kxms+Y0IysdJ+okLJggkbZAWB2SebtMzAu4/GZn
	9PSym2Z/OGrP4OIpF8OGyJogPnuIW68x3r3w==
X-Received: by 2002:a05:622a:49:b0:457:cab4:6e4a with SMTP id d75a77b69052e-45b2055bc72mr187303161cf.37.1727141268963;
        Mon, 23 Sep 2024 18:27:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFypRopa4f6KiHuSUC3JwYukJldcwyWuE/L7ifdh7cepC0UYoIUBdVQeRE89hIiJjr59B5KqfHxMctSrYeshag=
X-Received: by 2002:a05:622a:49:b0:457:cab4:6e4a with SMTP id
 d75a77b69052e-45b2055bc72mr187302961cf.37.1727141268671; Mon, 23 Sep 2024
 18:27:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904222952.937201-1-xiubli@redhat.com>
In-Reply-To: <20240904222952.937201-1-xiubli@redhat.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Mon, 23 Sep 2024 21:27:22 -0400
Message-ID: <CA+2bHPZDMF-N79ivAosSg6k5AArJS5-y-pyutM0w2EUw4m7=XQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove the incorrect Fw reference check when
 dirtying pages
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, vshankar@redhat.com, 
	gfarnum@redhat.com
Content-Type: text/plain; charset="UTF-8"

Fantastic work Xiubo.

Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


