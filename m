Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4543717B8
	for <lists+ceph-devel@lfdr.de>; Mon,  3 May 2021 17:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhECPVA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 May 2021 11:21:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230122AbhECPU5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 May 2021 11:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620055203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hqDZnBUhMAQ8HdatrCtwVe4WYzSDRxkHLwIxw/ueq0g=;
        b=hVqouafhaubgWwhnWOFeDbM9nsOGaafuotZqUPSS+OalgD/HitlpYaGM/4XuZfOTWxAk9P
        fkqxTMACgycUh/5ZZt20hIM4+TnBKbPpwheexbhlJkc6f3cclhusq3xpIEUPzDjhihUs8H
        pd2DcHZIKn8V9C95Gyb4QyEgIW9d4/4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-IFPNiyVIOJePc6nru2pu2A-1; Mon, 03 May 2021 11:20:00 -0400
X-MC-Unique: IFPNiyVIOJePc6nru2pu2A-1
Received: by mail-ej1-f69.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so2192426ejz.5
        for <ceph-devel@vger.kernel.org>; Mon, 03 May 2021 08:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hqDZnBUhMAQ8HdatrCtwVe4WYzSDRxkHLwIxw/ueq0g=;
        b=tmzCffAuHNIyOIhcEtpEnPILDInutToRmzUwyTLqcNFa5sUWK/Gsez70n2A4vBDHPP
         m4nzIJ2arRWPDPpj/vpOABrDrk9rNA6OZ3cz3lCyj6DTyjod9Nj5Nr5NsZmJDhKw7CHS
         UM7tiYXxfkByxSKS7+Sq1INuGI3vPvJbuL7BL61UbyJHY7fVTFvq77jVcNsNrCkDyVOE
         /CrUkizR/dYAsn3bL1clEdl/UdHsg71mDBxcuwgF/gaGSLykILD7r0Zva3tPQP78sCIY
         5xq+1HcUzoAuIB0T94JSWOlWuxsZOn3JV0PBhVnlo0sCNs4Rfjyo7Vxc/9DQdmKrHRUd
         9v7A==
X-Gm-Message-State: AOAM533XRWXDNjvYzi/wtztRmL1VqNq4mfAhtsa05sWzMGcMNjIZxG9C
        O57sWPeszRaCWrGePv0s3aQaR+aXtdtQQI5T3y9xfCK2NLoVHzv88R01duznotoXVcxnQpH7URd
        BkUb5M6Dx1uOL4EyMbsj2B4XB2jear6/xliXvKA==
X-Received: by 2002:a17:906:e118:: with SMTP id gj24mr17425324ejb.205.1620055199700;
        Mon, 03 May 2021 08:19:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcrjq7wM4kAZqQ8UCZc7z8lajzUBq2v0Zwi+n28pjXf8t5M7JXMbUQnqcoK89tD/aPm66T5N/ubXRVQQ98Ovs=
X-Received: by 2002:a17:906:e118:: with SMTP id gj24mr17425305ejb.205.1620055199575;
 Mon, 03 May 2021 08:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAJm6b-741TRptPWOqoqEJG6m00auekTkcWUD+z3sxH1-34THgA@mail.gmail.com>
In-Reply-To: <CAJm6b-741TRptPWOqoqEJG6m00auekTkcWUD+z3sxH1-34THgA@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Mon, 3 May 2021 08:19:37 -0700
Message-ID: <CA+2bHPaotXm-SK7Pi0WqL1wb4=MD+xvJr4hQGprk897LHt5qCQ@mail.gmail.com>
Subject: Re: [ceph-users] [ Ceph MDS MON Config Variables ] Failover Delay issue
To:     Lokendra Rathour <lokendrarathour@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>,
        ceph-users <ceph-users@ceph.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, May 3, 2021 at 6:36 AM Lokendra Rathour
<lokendrarathour@gmail.com> wrote:
>
> Hi Team,
> I was setting up the ceph cluster with
>
>    - Node Details:3 Mon,2 MDS, 2 Mgr, 2 RGW
>    - Deployment Type: Active Standby
>    - Testing Mode: Failover of MDS Node
>    - Setup : Octopus (15.2.7)
>    - OS: centos 8.3
>    - hardware: HP
>    - Ram:  128 GB on each Node
>    - OSD: 2 ( 1 tb each)
>    - Operation: Normal I/O with mkdir on every 1 second.
>
> T*est Case: Power-off any active MDS Node for failover to happen*
>
> *Observation:*
> We have observed that whenever an active MDS Node is down it takes around*
> 40 seconds* to activate the standby MDS Node.
> on further checking the logs for the new-handover MDS Node we have seen
> delay on the basis of following inputs:
>
>    1. 10 second delay after which Mon calls for new Monitor election
>       1.  [log]  0 log_channel(cluster) log [INF] : mon.cephnode1 calling
>       monitor election

In the process of killing the active MDS, are you also killing a monitor?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

