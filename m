Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5FC75774
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 20:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfGYS7p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 14:59:45 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40797 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGYS7p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 14:59:45 -0400
Received: by mail-qk1-f194.google.com with SMTP id s145so37253733qke.7
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:59:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Spqia9w4n2GeovFHM8IMllhSHuKE084RgYBBEVSmjLI=;
        b=qvVhq+X2/e/cpz9NOaiMHj7+MZIySRmc8rWNCJ3WMR/gDRA+xxmb75xCCzk2wNh9fT
         lIbvIhUc81XduP2sEFf3Z2koizto1zFUM1n5WXaw+yMeztdRW1ryGY9ZHVv01dTSDa8P
         KRoJo1k23Gsdqut4JgmqosC53G4Kgrx39TvMQtgVwFX0VRsn50MG8glqhJYoevXQXwE/
         +KarGgHlaE/9kNbDVOswuBb+8rTn8S+9p7eVFJ318ns3MkoWEGf4yhnUcuMnu8k1uxCD
         Vl6lAaZFP6uZfJdiQTFRM6vY2pLeDfKvn0crAjQIl8Lj5GLHby+Am7sC0ytBuXfWnVbT
         xB6Q==
X-Gm-Message-State: APjAAAWLGhT5BZIc0d7TmZANN3MDODzJX0WTU5A5he8pYwVv+xsEYAoD
        redA1aLxJxNL8pii6M2BKHt9RtNolSood+QDKTyUJw==
X-Google-Smtp-Source: APXvYqwz35C/il+37BPzwvKKITrXGEFWjcT/mBaDBM5wNeh7kP2QmuYobUKHBKKzwLrRHYvPQddVtrJWelAcq/YB2ww=
X-Received: by 2002:a37:9644:: with SMTP id y65mr59266247qkd.191.1564081184033;
 Thu, 25 Jul 2019 11:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAHRQ3VVjW31oiGnoiZfLhpQUGpN6AHrsENTeNUPWpPXs5bAbxw@mail.gmail.com>
In-Reply-To: <CAHRQ3VVjW31oiGnoiZfLhpQUGpN6AHrsENTeNUPWpPXs5bAbxw@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Thu, 25 Jul 2019 11:59:31 -0700
Message-ID: <CAJ4mKGYHOj+vi6JEOeCz91dkMEG5FqdSrP0L_QRjc10fHD9M0A@mail.gmail.com>
Subject: Re: Implement QoS for CephFS
To:     Songbo Wang <songbo1227@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 24, 2019 at 8:29 PM Songbo Wang <songbo1227@gmail.com> wrote:
>
> Hi guys,
>
> As a distributed filesystem, all clients of CephFS share the whole
> cluster's resources, for example, IOPS, throughput. In some cases,
> resources will be occupied by some clients. So QoS for CephFS is
> needed in most cases.
>
> Based on the token bucket algorithm, I implement QoS for CephFS.
>
> The basic idea is as follows:
>
>   1. Set QoS info as one of the dir's xattrs;
>   2. All clients can access the same dirs with the same QoS setting.
>   3. Similar to the Quota's config flow. when the MDS receives the QoS
> setting, it'll also broadcast the message to all clients.
>   4. We can change the limit online.
>
>
> And we will config QoS as follows, it supports
> {limit/burst}{iops/bps/read_iops/read_bps/write_iops/write_bps}
> configure setting, some examples:
>
>       setfattr -n ceph.qos.limit.iops           -v 200 /mnt/cephfs/testdirs/
>       setfattr -n ceph.qos.burst.read_bps -v 200 /mnt/cephfs/testdirs/
>       getfattr -n ceph.qos.limit.iops                      /mnt/cephfs/testdirs/
>       getfattr -n ceph.qos
> /mnt/cephfs/testdirs/
>
>
> But, there is also a big problem. For the bps{bps/write_bps/read_bps}
> setting, if the bps is lower than the request's block size, the client
> will be blocked until it gets enough token.
>
> Any suggestion will be appreciated, thanks!
>
> PR: https://github.com/ceph/ceph/pull/29266

I briefly skimmed this and if I understand correctly, this lets you
specify a per-client limit on hierarchies. But it doesn't try and
limit total IO across a hierarchy, and it doesn't let you specify
total per-client limits if they have multiple mount points.

Given this, what's the point of maintaining the QoS data in the
filesystem instead of just as information that's passed when the
client mounts?
How hard is this scheme likely to be to implement in the kernel?
-Greg
