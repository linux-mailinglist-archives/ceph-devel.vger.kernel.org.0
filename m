Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9E8FBDF6
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 03:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfKNCgU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 21:36:20 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:41414 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKNCgU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 21:36:20 -0500
Received: by mail-ot1-f42.google.com with SMTP id 94so3544982oty.8
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 18:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VpUQGGAHeGKvH0uv0MKdLbYJoy8FYFlU3E6qdtnQrA0=;
        b=In7XNFVNGnJ6DsWU6WXZY0kFm6H/7TOrD7Nwm9AwA1GfiMZFiax+ByRAbIzuisn2ku
         F7Y+Lv0Yh6fRnp9KXhpTwq3KHfjWxikdYYLGVskg5XISjVYZROimSs05leIEKM5iNiRm
         BRPKxddCyfmmHhGtQQCNGCmggdkGjF3H4lxqdseLF58WdQP72pqll5Ep9XQcejaDr4fs
         B+9LAZBn9K8h0h+vTHOz5KVKKJKbnuA2CVBd8U99TwDGUO2wjiUF4VM5o+33GxINgQxW
         MH2Y1S/rCaOSCgg29QidtmDr8e1MSYpl1BKvda32kxf/WBgpOWz9IIgh2IKgle9FmhwG
         ke2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VpUQGGAHeGKvH0uv0MKdLbYJoy8FYFlU3E6qdtnQrA0=;
        b=URgZ2lsGEFasFtUZ+/FaC5f6jvpyMpiBhEALrhB+wVpb0eBSJTVu33jEhjOltX1F9T
         WvjlpAWrjlIsPKxqzkm9F1FbqKBXXeya7+1X8gsdneYahbW5SqavUr2jXLhcVQav1jAG
         whwAbhZr/wj0bnTNhnBcPIdQtkGyytLygXfBtsMtSNI2dk9i7NHjbMLrf2AyCn2gc5KK
         po+mF4NdqI5BP43NmRdsntuUQys1NqAmUgGWwax+pMzBJyKp94xPAXk1rWdxYzH8dbJF
         VyrxlTP9D0r1EOKRwzYBYxn44HUu8r4EATsqCntaNs6v5xIap64O/aTfnpTVfYVeDH9s
         cVdA==
X-Gm-Message-State: APjAAAVx4LtVmmlXEnhyi1jKBMXUHC9RRLBTjc3FPzXcmPq7cbQZ+Ve9
        7u0ndsm+ank8BmZDi8rHp3cu71+OBTSImpm86UTCpw==
X-Google-Smtp-Source: APXvYqwoaV5ufGK5x0fY77/yuHno3eUixnM2TmkP4rYapWOqY61pTogpwInVxt578/+TPqzQiu8pMxJnDbWrSPklMn0=
X-Received: by 2002:a9d:7a4a:: with SMTP id z10mr6072529otm.283.1573698978763;
 Wed, 13 Nov 2019 18:36:18 -0800 (PST)
MIME-Version: 1.0
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
 <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com>
In-Reply-To: <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com>
From:   Jerry Lee <leisurelysw24@gmail.com>
Date:   Thu, 14 Nov 2019 10:36:05 +0800
Message-ID: <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 14 Nov 2019 at 07:07, Patrick Donnelly <pdonnell@redhat.com> wrote:
>
> On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wrote:
> > Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> > client and everthing works like a charm.  But, it seems that reverting
> > a snapshot is not available currently.  Is there some reason or
> > technical limitation that the feature is not provided?  Any insights
> > or ideas are appreciated.
>
> Please provide more information about what you tried to do (commands
> run) and how it surprised you.

The thing I would like to do is to rollback a snapped directory to a
previous version of snapshot.  It looks like the operation can be done
by over-writting all the current version of files/directories from a
previous snapshot via cp.  But cp may take lots of time when there are
many files and directories in the target directory.  Is there any
possibility to achieve the goal much faster from the CephFS internal
via command like "ceph fs <cephfs_name> <dir> snap rollback
<snapname>" (just a example)?  Thank you!


- Jerry

>
> --
> Patrick Donnelly, Ph.D.
> He / Him / His
> Senior Software Engineer
> Red Hat Sunnyvale, CA
> GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>
