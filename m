Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD928629B
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 17:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgJGPxW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 11:53:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgJGPxW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Oct 2020 11:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602086000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSBrzBtsZ3pm17O1OH+6g773pIF0WXZCPLM/UYM1ws0=;
        b=KvXvSonfdsKrbKi5Trs1Fxh8eVk+LKzs7qBiJK91/RXl65Pgzm1hhgI7RkvperSzTsa0Y8
        b/H/UumwRNO4SBNJjnrsn8L40mB6LnYu9ucDOsztw19UPDnNjSex41dyM7TwKEA63Vl+XM
        Bp9KN8R9i4cQvHglBT4DG/3Ia4znUfc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-NjSHHLUxPw6JufV7LFQd4w-1; Wed, 07 Oct 2020 11:53:18 -0400
X-MC-Unique: NjSHHLUxPw6JufV7LFQd4w-1
Received: by mail-il1-f198.google.com with SMTP id a14so1919269iln.11
        for <ceph-devel@vger.kernel.org>; Wed, 07 Oct 2020 08:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XSBrzBtsZ3pm17O1OH+6g773pIF0WXZCPLM/UYM1ws0=;
        b=HhRubl1JoHoMKh+aVW8Uxjv/LH4yp2g6f4iwwJR1sBZJHjHcspyivp+U6OR+/Lm0lh
         jXb4DhO7+L/niZIdNUuwpHAU3RItru+x5qZhvDCxp/uDZjS6fkiv3yYz9DmcnuYFexd4
         ACWvQAGXwX5KUZxeI6bz7aiAKhUS9RghZnlhUhMHXdjA7xUYl50JBYORORDZxuehZwtn
         LLJw6gCvk2hWQMytdqSmgptNphKUhCj45YcKkiKtEN6uj4tecZ0+afkdLljOEUOCcjfd
         yj0f1GEDxsiFjEtLZRzetEKPAdSGsn/ZW+aa2rrEQtG8XCltAF3/gIg5XoYktylcnYn9
         Xzcg==
X-Gm-Message-State: AOAM531T4s/08kfUirM2JS3O8FaLTXE86F3eISF5BgiDV/DgMkUKoHVg
        NB4qJUP1fhreF/+RjGhp1CgVY2CoYaNKgHN9ywY4Nup5jzeUomluSEaL92rRGFA90FN27UB4dRp
        OktQOW0Cz1Ob8Eta5mk35SE7CUiXD8KiRS7AYqw==
X-Received: by 2002:a05:6638:24c1:: with SMTP id y1mr3357433jat.119.1602085996738;
        Wed, 07 Oct 2020 08:53:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrFE7oeAV5IBtyJKr/lIucSLEMcipG5usbTZUIBIFJ6tSMKtbyNtD7Icu8fIdvXheEUSz9A7NYSLfI/U6cPBk=
X-Received: by 2002:a05:6638:24c1:: with SMTP id y1mr3357410jat.119.1602085996406;
 Wed, 07 Oct 2020 08:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
In-Reply-To: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 7 Oct 2020 08:52:50 -0700
Message-ID: <CA+2bHPaAxh8uy8PW81H63vP3GRWp4NbsDuPSSSX9HH_AMhgR2g@mail.gmail.com>
Subject: Re: Rook orchestrator module
To:     Travis Nielsen <tnielsen@redhat.com>
Cc:     Sebastian Wagner <swagner@suse.com>, Varsha Rao <varao@redhat.com>,
        Sebastien Han <seb@redhat.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>,
        dev <dev@ceph.io>, Venky Shankar <vshankar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adding in dev@ceph.io. ceph-devel is now for kernel development but
I'm keeping it in the cc list because a lot of discussion already
happened there.

Also for those interested, there's a recording of a meeting we had on
this topic here: https://www.youtube.com/watch?v=3D1OSQySElojg

On Tue, Sep 29, 2020 at 12:32 PM Travis Nielsen <tnielsen@redhat.com> wrote=
:
>
> Sebastian and fellow orchestrators,
>
> Some questions have come up recently about issues in the Rook
> orchestrator module and its state of disrepair. Patrick, Varsha, and I
> have been discussing these recently as Varsha has been working on the
> module. Before we fix all the issues that are being found, I want to
> start a higher level conversation. I=E2=80=99ll join the leads meeting
> tomorrow to discuss, and would be good to include in the Monday
> orchestrator agenda as well, which unfortunately I haven=E2=80=99t been a=
ble
> to attend recently...
>
> First, Rook is driven by the K8s APIs, including CRDs, an operator,
> the CSI driver, etc. When the admin needs to configure the Ceph
> cluster, they create the CRDs and other resources directly with the
> K8s tools such as kubectl. Rook does everything with K8s patterns so
> that the admin doesn=E2=80=99t need to leave their standard administratio=
n
> sandbox in order to configure Rook or Ceph. If any Ceph-specific
> command needs to be run, the rook toolbox can be used. However, we
> prefer to avoid the toolbox for common scenarios that should have CRDs
> for declaring desired state.

We're at a crossroads here. Ceph is increasingly learning to manage
itself with a primary goal of increasing user friendliness. Awareness
of the deployment technology is key to that.

> The fundamental question then is, **what scenarios require the Rook
> orchestrator mgr module**? The module is not enabled by default in
> Rook clusters and I am not aware of upstream users consuming it.
>
> The purpose of the orchestrator module was originally to provide a
> common entry point either for Ceph CLI tools or the dashboard. This
> would provide the constant interface to work with both Rook or cephadm
> clusters. Patrick pointed out that the dashboard isn=E2=80=99t really a
> scenario anymore for the orchestrator module.

As Lenz pointed out in another reply, my understanding was wrong here.
Dashboard has been using the orchestrator for displaying information
from the orchestrator.

> If so, the only
> remaining usage is for CLI tools. And if we only have the CLI
> scenario, this means that the CLI commands would be run from the
> toolbox. But we are trying to avoid the toolbox. We should be putting
> our effort into the CRDs, CSI driver, etc.

I think we need to be careful about looking at the CLI as the sole
entry point for the orchestrator. The mgr modules (including the
dashboard) are increasingly using the orchestrator to do tasks. As we
discussed in the orchestrator meeting (youtube linked earlier in this
mail) CephFS is planning these scenarios for Pacific:

- mds_autoscaler plugin deploys MDS in response to file system
degradation (increased max_mds, insufficient standby). Future work [1]
will look at deploying MDS with more memory in response to load on the
file system. (Think lots of small file systems with small MDS to
start.)

- volumes plugin deploys NFS clusters configured via the `ceph nfs
...` command suite.

- cephfs-mirror daemons deployed to geo-replicate CephFS file systems.

- (Still TBD:) volumes plugin to use an rsync container to copy data
between two CephFS subvolumes (encrypted or not). Probably include RBD
mounted images as source or destination, at some point.

> If the orchestrator module is creating CRs, we are likely doing
> something wrong. We expect the cluster admin to create CRs.
>
> Thus, I=E2=80=99d like to understand the scenarios where the rook orchest=
rator
> module is needed. If there isn=E2=80=99t a need anymore since dashboard
> requirements have changed, I=E2=80=99d propose the module can be removed.

Outside of this thread I think we already decided not to do this but
I'm still interested to hear everyone's thoughts. Hopefully broader
exposure on dev@ceph.io will get us more voices.

[1] https://tracker.ceph.com/issues/46680

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

