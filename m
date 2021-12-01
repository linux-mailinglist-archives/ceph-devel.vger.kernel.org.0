Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A22946573C
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Dec 2021 21:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352955AbhLAUlx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Dec 2021 15:41:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40290 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352909AbhLAUjq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Dec 2021 15:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638390984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=327TNWql3wWdeatc5tbAId7z+H1nubHHchgbDAGGAu0=;
        b=PZ8m5I3GiVOF0LkYRjiqU35tPknndzU1OlLhGVPf10UCt6qG9p/e/7N6Bol5KTSc99JtSY
        3yIZBGwaxbt3tjiUedJPFifa4o0Z8ZESbQLPh1p+fdVAJe++veP4v/H0mAai9XyjzoOoED
        nr6PRhMKSmcnVi/AWNsIzzYQeWCSXg4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-6d45Y_6GOk-jCdLScdfs4Q-1; Wed, 01 Dec 2021 15:36:23 -0500
X-MC-Unique: 6d45Y_6GOk-jCdLScdfs4Q-1
Received: by mail-pj1-f71.google.com with SMTP id p8-20020a17090a748800b001a6cceee8afso9376655pjk.4
        for <ceph-devel@vger.kernel.org>; Wed, 01 Dec 2021 12:36:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=327TNWql3wWdeatc5tbAId7z+H1nubHHchgbDAGGAu0=;
        b=ztcFbiynUzE/Ws3ZdGdshIjbcDMqHEGNYlMLTpVBYSVHjpQ4OaPJD9gcMO25uEMjIq
         4N3sVg15a3x7ZiiPHVNAkvHR17NN057+5nRYkuO8CtWwHGDNUPYJHezoKrnq8P+VW8Pg
         LOlIRBIyv+GkV8W3BXrVyRc559MWfQSWluvjEhC4ivIG8atyT+IOADPDOIlM1wmwr+pP
         VBLdnEqHBGxne7yUlQpl5CN0S+Vh0UnLKc92+9BY7nDK8hJrqnQo3hS8DWU9XTv326TA
         Y0zwsdOi+pD3ehXKF/7TL7E4Hg2sQaR4MJ20WKwZqkRZRwuUScs2YPF4mfgRmdk5JskK
         0NlQ==
X-Gm-Message-State: AOAM530ZAQ4WcMMKgO8mvVkH78Sefkgk9E4foU2T7vKEGeIswOpkRFMw
        TEFP/Y+bjA9Mz0f1dFuKwKJYxwaEHF/n6Y46Jrt2nOPDyCT2cgAD5tsEE0n/+UbO7PJyRU6VQge
        7/TDhyyv4ReG9LXt11KCoMnGA5jKRbcvcQDPbPg==
X-Received: by 2002:a17:90a:cb98:: with SMTP id a24mr640460pju.69.1638390982431;
        Wed, 01 Dec 2021 12:36:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzFjbR3XIUyohTmLZlx7NKJFJvOwqh7rv3HTHa/KwBg7it8TqmOzXITJ0dMvZWcyX8j3fh0EExljghMKZMHoiU=
X-Received: by 2002:a17:90a:cb98:: with SMTP id a24mr640418pju.69.1638390982021;
 Wed, 01 Dec 2021 12:36:22 -0800 (PST)
MIME-Version: 1.0
References: <CAFFUGJdht8P0K+vFLFbuGOYeW2SAUuPbHMw3OZ5vgqETZBPVfg@mail.gmail.com>
In-Reply-To: <CAFFUGJdht8P0K+vFLFbuGOYeW2SAUuPbHMw3OZ5vgqETZBPVfg@mail.gmail.com>
From:   Mike Perez <thingee@redhat.com>
Date:   Wed, 1 Dec 2021 12:35:55 -0800
Message-ID: <CAFFUGJf72qg3UgRc-efxzFY+zF8jPbo5osnAptvU_pkU7wv3DQ@mail.gmail.com>
Subject: Re: Cephalocon 2022 is official!
To:     Ceph Development <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi everyone,

We're near the deadline of December 10th for the Cephalocon CFP. So
don't miss your chance to speak at this event either in-person or
virtually.

https://ceph.io/en/community/events/2022/cephalocon-portland/

If you're interested in sponsoring Cephalocon, the sponsorship
prospectus is now available:

https://ceph.io/assets/pdfs/cephalocon-2022-sponsorship-prospectus.pdf

On Fri, Nov 5, 2021 at 10:06 AM Mike Perez <thingee@redhat.com> wrote:
>
> Hello everyone!
>
> I'm pleased to announce Cephalocon 2022 will be taking place April 5-7
> in Portland, Oregon + Virtually!
>
> The CFP is now open until December 10th, so don't delay! Registration
> and sponsorship details will be available soon!
>
> I am looking forward to seeing you all in person again soon!
>
> https://ceph.io/en/community/events/2022/cephalocon-portland/
>
> --
> Mike Perez

