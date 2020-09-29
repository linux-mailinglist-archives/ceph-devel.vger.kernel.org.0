Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC327D747
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 21:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbgI2Tun (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 15:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728747AbgI2Tum (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 15:50:42 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601409041;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dlJWcDjGgnfbgddPaCo39wIxWcZhx0WuG1gVCYgGQc=;
        b=SEeBFxnZb3PHC8B6Nvl5guD7Kt5p75Tlv8T0R6aD+Kwcda62KwDeqrKZYgzFoQdPQmsk9F
        TBDgRftF4n/2XaJOSQXWeZ8iIPABCp0l2XZFRR+SL6+mZfs4448n23cSWXxpgxujbaklFL
        I1COGCwlRzlvDzZn+aCg3wrh3nzqTzg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-bOcV3eZ7N52UPAV0KXCMuw-1; Tue, 29 Sep 2020 15:50:35 -0400
X-MC-Unique: bOcV3eZ7N52UPAV0KXCMuw-1
Received: by mail-wr1-f71.google.com with SMTP id d9so2177690wrv.16
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 12:50:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=6dlJWcDjGgnfbgddPaCo39wIxWcZhx0WuG1gVCYgGQc=;
        b=P970fyKwmRQRZtyh5UmSL8Lc+WBJcz76zKCkSmzy2QDmbyeerg6XLIWz+fFbHmRNQm
         br9Qe5mNZ8YJARgtzTUu8Hyx4yIkCoyaKq81QiFu/LkA0uoNAg7Iym/JBIHEYyLzQh5r
         BgRMf3TCkK7lb0OY4ek/GBgChwuYktVMlArtscJUtaT+B7/wks0kmPw9tRqbdipGOZCY
         OhPljYg7wc1NW4T08sJW6GO2dF7o5FZh/H/c16CtshEJ+LdH60tE08h8OVBaUI54QAwo
         e1V9nz7AIYV0vnOyO3c/74MVR/jYxjIJFNTM+vFx6eIhOFCvL5s/8KBi7GAH3/oVRO6V
         iwwA==
X-Gm-Message-State: AOAM533EO6Neyi4rxjs1HBuciDoqgXzEWYxH9nvtoI3BL7ayISTBAL//
        fHmsMfPgxjYWfCO4fE1l5gQg62IX89zBNLVzy/HDWXTf54nqSKTmOnvspwa6Q4qjDr74dTAa6aG
        zC9douvncUXS3iAvVWg7B/I8hC/71k0rJpsX8Vw==
X-Received: by 2002:a1c:e389:: with SMTP id a131mr6416166wmh.181.1601409034393;
        Tue, 29 Sep 2020 12:50:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+xb/y3go4IZR1751e6x/aLhrMWuUNpLnJUz4Ui598K/wUI+1JqQYmVz2TruvBEJoFmaXkbkz9kXHdOsw59AE=
X-Received: by 2002:a1c:e389:: with SMTP id a131mr6416151wmh.181.1601409034162;
 Tue, 29 Sep 2020 12:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
In-Reply-To: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Tue, 29 Sep 2020 15:50:22 -0400
Message-ID: <CA+aFP1AsO3CZA37ai6Tpqyd4gEN+BzeaC6BzUT+VnK7JKtxN3w@mail.gmail.com>
Subject: Re: Rook orchestrator module
To:     Travis Nielsen <tnielsen@redhat.com>
Cc:     Sebastian Wagner <swagner@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Varsha Rao <varao@redhat.com>, Sebastien Han <seb@redhat.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 3:33 PM Travis Nielsen <tnielsen@redhat.com> wrote:
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
>
> The fundamental question then is, **what scenarios require the Rook
> orchestrator mgr module**? The module is not enabled by default in
> Rook clusters and I am not aware of upstream users consuming it.
>
> The purpose of the orchestrator module was originally to provide a
> common entry point either for Ceph CLI tools or the dashboard. This
> would provide the constant interface to work with both Rook or cephadm
> clusters. Patrick pointed out that the dashboard isn=E2=80=99t really a
> scenario anymore for the orchestrator module.

Is that true? [1]

> If so, the only
> remaining usage is for CLI tools. And if we only have the CLI
> scenario, this means that the CLI commands would be run from the
> toolbox. But we are trying to avoid the toolbox. We should be putting
> our effort into the CRDs, CSI driver, etc.
>
> If the orchestrator module is creating CRs, we are likely doing
> something wrong. We expect the cluster admin to create CRs.
>
> Thus, I=E2=80=99d like to understand the scenarios where the rook orchest=
rator
> module is needed. If there isn=E2=80=99t a need anymore since dashboard
> requirements have changed, I=E2=80=99d propose the module can be removed.

I don't have a current stake in the outcome, but I could foresee the
future need/desire for letting the Ceph cluster itself spin up
resources on-demand in k8s via Rook. Let's say that I want to convert
an XFS on RBD image to CephFS, the MGR could instruct the orchestrator
to kick off a job to translate between the two formats. I'd imagine
the same could be argued for on-demand NFS/SMB gateways or anywhere
else there is a delta between a storage administrator setting up the
basic Ceph system and Ceph attempting to self-regulate/optimize.

> Thanks,
> Travis
> Rook
>

[1] https://tracker.ceph.com/issues/46756

--=20
Jason

