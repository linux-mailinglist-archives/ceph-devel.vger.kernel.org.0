Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044FE27D9BE
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 23:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729350AbgI2VGD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 17:06:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726643AbgI2VGD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 17:06:03 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601413561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rxl11GptyXftjlILgfJfq5BJPGYwy6P0yDiH+xncc68=;
        b=cuKRCdHOtAR4HOWGxY0nN/2E9QJRTBhzxLhfi6xo7LXz1QHMFUbKjlPcLn5+JPvCSHfyzQ
        WZZtoPG5cCCcXB8WY62gEpHB6LMIM4PuP7MR1GxTnPj2fdpuLObW0r4I9FMmddRntu8rNC
        TX2Mr9U3q+oqoAZGIrpSt05nmROG2NA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-ekoY9uuyNlWYUbrNQ466mw-1; Tue, 29 Sep 2020 17:05:58 -0400
X-MC-Unique: ekoY9uuyNlWYUbrNQ466mw-1
Received: by mail-ot1-f69.google.com with SMTP id d10so3732918otf.17
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 14:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Rxl11GptyXftjlILgfJfq5BJPGYwy6P0yDiH+xncc68=;
        b=HdRoN8r3af6ueqO5YZxVeVafLich2YAZ68uLC9uTANNnMreBwzYg5mEdzpJklJ8yyy
         8wDr1YO2XavxnPmfrCMdXHAxHiTjeyee9GbxvVWH1K5OdYlDq9gVsgfEW071QuN/BIVX
         DJRpJa1p6iUucmPWLxHx8hZNbOyLK9n4s51hPeWRGhC1/kcQieNgwH/sq6WKO8zOSKpx
         ggIbSISgwwhMuEyjdtlIiRKZfU9mUoIIxp8nR6tdXuGm4tqjeGp2sFjb/HyB/pKZpxu7
         nLpSWHvxaUE3ux2B6fsXkDryKBgnX614YTDTocV7Zg2Hz2pdUIGlaKhXQZukR3xmUPk+
         43Rw==
X-Gm-Message-State: AOAM530B+AXuiTbWQY1fnkG5/lWljUs6rz2thowU40jZhF1l/3LpzZqu
        iGfxapsg1D1DpI4RIBq+wipx9ET1vfBFXJgO+B3oLOZks7JwMrvvOp11ZIh3DqnmMyLjWL1hq0e
        Ow147EJaT2FPI6ivF9pM/X5AyEfBqd+tbXBS/tQ==
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr4115356oto.297.1601413557034;
        Tue, 29 Sep 2020 14:05:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiEDmLOpbLcf3LRryHDzeySWewBEASVixOTKogsnO9CAudchODZl0Pk+IKyeVcnnz9EiSz7YfDXsn+prFbgjI=
X-Received: by 2002:a9d:7b48:: with SMTP id f8mr4115292oto.297.1601413555966;
 Tue, 29 Sep 2020 14:05:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
 <CA+aFP1AsO3CZA37ai6Tpqyd4gEN+BzeaC6BzUT+VnK7JKtxN3w@mail.gmail.com>
 <CAByD1q89xGQGGj4=ySAw_hrHCq+t3zp9u8CkY-ey0_oo-7ntxA@mail.gmail.com> <CA+aFP1Bxt9NgybrEKGRG2QDsxaoMqcHYyFOzLFeVZqc_AQW1_w@mail.gmail.com>
In-Reply-To: <CA+aFP1Bxt9NgybrEKGRG2QDsxaoMqcHYyFOzLFeVZqc_AQW1_w@mail.gmail.com>
From:   Travis Nielsen <tnielsen@redhat.com>
Date:   Tue, 29 Sep 2020 15:05:45 -0600
Message-ID: <CAByD1q-TkadH8-qKP_up5AzJjyaBq8-WgyZuU6TVGt_suVC+KQ@mail.gmail.com>
Subject: Re: Rook orchestrator module
To:     "Dillaman, Jason" <dillaman@redhat.com>,
        Sebastian Wagner <swagner@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Varsha Rao <varao@redhat.com>, Sebastien Han <seb@redhat.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adding reply-all this time...

On Tue, Sep 29, 2020 at 2:53 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Sep 29, 2020 at 4:47 PM Travis Nielsen <tnielsen@redhat.com> wrot=
e:
> >
> > On Tue, Sep 29, 2020 at 1:50 PM Jason Dillaman <jdillama@redhat.com> wr=
ote:
> > >
> > > On Tue, Sep 29, 2020 at 3:33 PM Travis Nielsen <tnielsen@redhat.com> =
wrote:
> > > >
> > > > Sebastian and fellow orchestrators,
> > > >
> > > > Some questions have come up recently about issues in the Rook
> > > > orchestrator module and its state of disrepair. Patrick, Varsha, an=
d I
> > > > have been discussing these recently as Varsha has been working on t=
he
> > > > module. Before we fix all the issues that are being found, I want t=
o
> > > > start a higher level conversation. I=E2=80=99ll join the leads meet=
ing
> > > > tomorrow to discuss, and would be good to include in the Monday
> > > > orchestrator agenda as well, which unfortunately I haven=E2=80=99t =
been able
> > > > to attend recently...
> > > >
> > > > First, Rook is driven by the K8s APIs, including CRDs, an operator,
> > > > the CSI driver, etc. When the admin needs to configure the Ceph
> > > > cluster, they create the CRDs and other resources directly with the
> > > > K8s tools such as kubectl. Rook does everything with K8s patterns s=
o
> > > > that the admin doesn=E2=80=99t need to leave their standard adminis=
tration
> > > > sandbox in order to configure Rook or Ceph. If any Ceph-specific
> > > > command needs to be run, the rook toolbox can be used. However, we
> > > > prefer to avoid the toolbox for common scenarios that should have C=
RDs
> > > > for declaring desired state.
> > > >
> > > > The fundamental question then is, **what scenarios require the Rook
> > > > orchestrator mgr module**? The module is not enabled by default in
> > > > Rook clusters and I am not aware of upstream users consuming it.
> > > >
> > > > The purpose of the orchestrator module was originally to provide a
> > > > common entry point either for Ceph CLI tools or the dashboard. This
> > > > would provide the constant interface to work with both Rook or ceph=
adm
> > > > clusters. Patrick pointed out that the dashboard isn=E2=80=99t real=
ly a
> > > > scenario anymore for the orchestrator module.
> > >
> > > Is that true? [1]
> >
> > Perhaps I misunderstood. If the dashboard is still a requirement, the
> > requirements will certainly be much higher to maintain support.
> >
> > >
> > > > If so, the only
> > > > remaining usage is for CLI tools. And if we only have the CLI
> > > > scenario, this means that the CLI commands would be run from the
> > > > toolbox. But we are trying to avoid the toolbox. We should be putti=
ng
> > > > our effort into the CRDs, CSI driver, etc.
> > > >
> > > > If the orchestrator module is creating CRs, we are likely doing
> > > > something wrong. We expect the cluster admin to create CRs.
> > > >
> > > > Thus, I=E2=80=99d like to understand the scenarios where the rook o=
rchestrator
> > > > module is needed. If there isn=E2=80=99t a need anymore since dashb=
oard
> > > > requirements have changed, I=E2=80=99d propose the module can be re=
moved.
> > >
> > > I don't have a current stake in the outcome, but I could foresee the
> > > future need/desire for letting the Ceph cluster itself spin up
> > > resources on-demand in k8s via Rook. Let's say that I want to convert
> > > an XFS on RBD image to CephFS, the MGR could instruct the orchestrato=
r
> > > to kick off a job to translate between the two formats. I'd imagine
> > > the same could be argued for on-demand NFS/SMB gateways or anywhere
> > > else there is a delta between a storage administrator setting up the
> > > basic Ceph system and Ceph attempting to self-regulate/optimize.
> >
> > If Ceph needs to self regulate, I could certainly see the module as
> > useful, such as auto-scaling the daemons when load is high. But at the
> > same time, the operator could watch for Ceph events, metrics, or other
> > indicators and perform the self-regulation according to the CR
> > settings, instead of it happening inside the mgr module.
>
> But then you would be embedding low-level business logic about Ceph
> inside Rook? Or if you are saying Rook would wait for a special event
> / alert hook from Ceph to perform some action. If that's the case, it
> sounds a lot like what the orchestrator purports to do (at least to me
> and at least as an end-state goal).

Agreed we don't want to embed Ceph logic in Rook. But yes, if Rook can
have a hook into Ceph to perform the action, the operator could handle
it. Then if cephadm needed to handle the same scenario, it might use a
mgr module to implement. But no need for a rook module in that case.

>
> > At the end of the day, I want to make sure we actually need an
> > orchestrator interface. K8s and cephadm are very different
> > environments and their features probably won't ever be at parity with
> > each other. It may be more appropriate to define the rook and cephadm
> > module separately. Or at least we need to be very clear why we need
> > the common interface, that it's tested, and supported.
>
> Not going to disagree with that last point.
>
> > >
> > > > Thanks,
> > > > Travis
> > > > Rook
> > > >
> > >
> > > [1] https://tracker.ceph.com/issues/46756
> > >
> > > --
> > > Jason
> > >
> >
>
>
> --
> Jason
>

