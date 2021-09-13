Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883D640972A
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244021AbhIMPXp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 11:23:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343497AbhIMPWx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:22:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631546497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rc6Uk2Okk+Nbu5SvsfDkiv6o3DjXMjgSBGnyRqqpFsU=;
        b=eyaGmo2g2WKakMFqO60K6NKeK4U/Jw76CH3tBia0U7rnTr17rZIzy12kG1VisXhMUKIQrb
        TzoQYGWajcV2KL3411tjDsqrnbfXFhmhkg9r4TksYv8exdYpllO3lDNGvU10LdFXPsHxBh
        9OJt9iMzLhQ5s7YWJjT3K9S3u1qMTCk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-VNZOwOryPmyzsQgdiz4i4A-1; Mon, 13 Sep 2021 11:21:36 -0400
X-MC-Unique: VNZOwOryPmyzsQgdiz4i4A-1
Received: by mail-qv1-f69.google.com with SMTP id b8-20020a0562141148b02902f1474ce8b7so56405207qvt.20
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 08:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rc6Uk2Okk+Nbu5SvsfDkiv6o3DjXMjgSBGnyRqqpFsU=;
        b=Xb1RP+Cse9sESjnGqF/OwIf/4lUBTFiZUkrUli3nZp6TkY/q9pMMTHOFjmgcSgF/z2
         wZto3VuZymd+uVSFYemOZlri/qOZTS28UYfPjQimhiEskQjvos/boHjp+nHk92qgaKbb
         IA9rf7XwtoQ5O5TLwgwVhEtXeNaocQ8N2QGZDnwDc9Ucoeaqq05+Z8OfH7E9mcVsNWKO
         kTc9yCCnE4KjlEl7fxnwAVBVIOJhU5BYiesjuxh9EhA64iAEM6JNKB9zDHh4n1zYyrMk
         1xu2SXfky+mV7hMKKu9FN1uZ2fsFgcm1Fhqpf8hHsfSiruID8yiSefMhrUijK6B8mM/r
         Ds4g==
X-Gm-Message-State: AOAM532Ocbl5d7hAde2H7uze6i8s5AFIjjIbgMhDhVqXOFeF2C7bqK9J
        ikhPDGgSZ7dxwEk4KFwSU2ULph4PhlhBj+kaBfW26UB9hXDDzNkpBZl8ZA+Bn+Myt9D1eJHHwHh
        cU4V7gQSCW0vU3qPH9Emi7Q==
X-Received: by 2002:ae9:ed53:: with SMTP id c80mr132567qkg.402.1631546495567;
        Mon, 13 Sep 2021 08:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8VthSrCAUwJG9SUqkXmbk5hvjtUPwOZSBWdTUTrrDIss2mesD4u5Nodz13ostoHemjQq8cA==
X-Received: by 2002:ae9:ed53:: with SMTP id c80mr132544qkg.402.1631546495335;
        Mon, 13 Sep 2021 08:21:35 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id e25sm5474029qka.83.2021.09.13.08.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 08:21:34 -0700 (PDT)
Message-ID: <a79f35e47a105bb24baa666bca8c7cfe956d5076.camel@redhat.com>
Subject: Re: [PATCH v1 0/4] ceph: forward average read/write/metadata latency
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, pdonnell@redhat.com,
        xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 13 Sep 2021 11:21:34 -0400
In-Reply-To: <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
References: <20210913131311.1347903-1-vshankar@redhat.com>
         <22e110d00df3d02157222754f01fc6143cb40764.camel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-09-13 at 11:13 -0400, Jeff Layton wrote:
> On Mon, 2021-09-13 at 18:43 +0530, Venky Shankar wrote:
> > Right now, cumulative read/write/metadata latencies are tracked
> > and are periodically forwarded to the MDS. These meterics are not
> > particularly useful. A much more useful metric is the average latency
> > and standard deviation (stdev) which is what this series of patches
> > aims to do.
> > 
> > The userspace (libcephfs+tool) changes are here::
> > 
> >           https://github.com/ceph/ceph/pull/41397
> > 
> > The math involved in keeping track of the average latency and stdev
> > seems incorrect, so, this series fixes that up too (closely mimics
> > how its done in userspace with some restrictions obviously) as per::
> > 
> >           NEW_AVG = OLD_AVG + ((latency - OLD_AVG) / total_ops)
> >           NEW_STDEV = SQRT(((OLD_STDEV + (latency - OLD_AVG)*(latency - NEW_AVG)) / (total_ops - 1)))
> > 
> > Note that the cumulative latencies are still forwarded to the MDS but
> > the tool (cephfs-top) ignores it altogether.
> > 
> > Venky Shankar (4):
> >   ceph: use "struct ceph_timespec" for r/w/m latencies
> >   ceph: track average/stdev r/w/m latency
> >   ceph: include average/stddev r/w/m latency in mds metrics
> >   ceph: use tracked average r/w/m latencies to display metrics in
> >     debugfs
> > 
> >  fs/ceph/debugfs.c | 12 +++----
> >  fs/ceph/metric.c  | 81 +++++++++++++++++++++++++----------------------
> >  fs/ceph/metric.h  | 64 +++++++++++++++++++++++--------------
> >  3 files changed, 90 insertions(+), 67 deletions(-)
> > 
> 
> This looks reasonably sane. I'll plan to go ahead and pull this into the
> testing kernels and do some testing with them. If anyone has objections
> (Xiubo?) let me know and I can take them out.
> 
> Thanks,

Hmm...I take it back. There are some non-trivial merge conflicts in this
series vs. the current testing branch. Venky can you rebase this onto
the ceph-client/testing branch and resubmit?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

