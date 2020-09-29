Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DED27D6F0
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 21:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgI2TcG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 15:32:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727740AbgI2TcF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 15:32:05 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601407924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nn1woEeMg61Rtc2LKR9gFjh4fGespwdwrZCxEwurDQE=;
        b=EAyDGqQZ7vOhH/NOJfIyGLs3Fa6tneG95WSb9lRyG08FDgt6lePU27Z+6PjJqgqsyyfkw0
        NemTUf38AxJCuG0lF+KHflDn1xIXZ3+NXmmeznAB8wZXHzNqJv2R+JmIe99zyIs03N8bf6
        Eu7M3ypfXLoVJmnV8NSgDbTV/wNz8hU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-a6-5UMxqMk-kwHSrJBRaDw-1; Tue, 29 Sep 2020 15:32:00 -0400
X-MC-Unique: a6-5UMxqMk-kwHSrJBRaDw-1
Received: by mail-oi1-f200.google.com with SMTP id c126so2051656oib.8
        for <ceph-devel@vger.kernel.org>; Tue, 29 Sep 2020 12:32:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=nn1woEeMg61Rtc2LKR9gFjh4fGespwdwrZCxEwurDQE=;
        b=SuZQgKNHb8xKTyvkEs7czCdCtvB3MfMV4pCm0qZKs7/C+jg1YteFIZaidcLiMNTUnW
         gtRVhvSmWy/5m2R8/iGREC/RuYAKJCKM7nAb/Rs/alMV8EKWhf7cQVHBEWNX+UVeT02a
         FEv5qSNQSo9e8xuFv5FyGOTowMNKymvO3IsstV2hx/0OjemtTbJIuon+jWuSaZ+KmOe7
         /MIWgzPFH+n0WIUFLKQMTQXW88sA3am8Elqny4/wcMAbN+23Ui4eTAl7TLt4DFNi/U5L
         RIC2faJubNCaycV1Zbqfm1E5qh+us8dtvs17XkF+e10mf3oE/F1jeri92/HGhonjfFZB
         MdCg==
X-Gm-Message-State: AOAM5332jwZY9Z4u8zamshRiF5gWGmcu4rrszhBo0z4oK6WkT7+Oj/Hg
        RHcwFU+ON+PDRnCSaHZ+RLU2nxS4PAxwwMquF0sMbFjuimajL7WVxqJii8fxyTIGQzPHbIxbgsd
        FcqKEk8A45gWHkt3xBw1YN7Hpg01UoS3xFxou2w==
X-Received: by 2002:a05:6830:1be6:: with SMTP id k6mr3978003otb.185.1601407919708;
        Tue, 29 Sep 2020 12:31:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4IHAJUq9E5dYdHkTRnCIFvYwp0hpcNvgO59ICGzXTqAG1JAdcznFtXIXvL+XikwvVxz8KZBqFlzoXfCewup0=
X-Received: by 2002:a05:6830:1be6:: with SMTP id k6mr3977984otb.185.1601407919294;
 Tue, 29 Sep 2020 12:31:59 -0700 (PDT)
MIME-Version: 1.0
From:   Travis Nielsen <tnielsen@redhat.com>
Date:   Tue, 29 Sep 2020 13:31:48 -0600
Message-ID: <CAByD1q-w83TQgCof5TJH0DWXPMobbqQQcbuaKsnE6PqNsaWqVw@mail.gmail.com>
Subject: Rook orchestrator module
To:     Sebastian Wagner <swagner@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Varsha Rao <varao@redhat.com>, Sebastien Han <seb@redhat.com>,
        Ceph Development List <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sebastian and fellow orchestrators,

Some questions have come up recently about issues in the Rook
orchestrator module and its state of disrepair. Patrick, Varsha, and I
have been discussing these recently as Varsha has been working on the
module. Before we fix all the issues that are being found, I want to
start a higher level conversation. I=E2=80=99ll join the leads meeting
tomorrow to discuss, and would be good to include in the Monday
orchestrator agenda as well, which unfortunately I haven=E2=80=99t been abl=
e
to attend recently...

First, Rook is driven by the K8s APIs, including CRDs, an operator,
the CSI driver, etc. When the admin needs to configure the Ceph
cluster, they create the CRDs and other resources directly with the
K8s tools such as kubectl. Rook does everything with K8s patterns so
that the admin doesn=E2=80=99t need to leave their standard administration
sandbox in order to configure Rook or Ceph. If any Ceph-specific
command needs to be run, the rook toolbox can be used. However, we
prefer to avoid the toolbox for common scenarios that should have CRDs
for declaring desired state.

The fundamental question then is, **what scenarios require the Rook
orchestrator mgr module**? The module is not enabled by default in
Rook clusters and I am not aware of upstream users consuming it.

The purpose of the orchestrator module was originally to provide a
common entry point either for Ceph CLI tools or the dashboard. This
would provide the constant interface to work with both Rook or cephadm
clusters. Patrick pointed out that the dashboard isn=E2=80=99t really a
scenario anymore for the orchestrator module. If so, the only
remaining usage is for CLI tools. And if we only have the CLI
scenario, this means that the CLI commands would be run from the
toolbox. But we are trying to avoid the toolbox. We should be putting
our effort into the CRDs, CSI driver, etc.

If the orchestrator module is creating CRs, we are likely doing
something wrong. We expect the cluster admin to create CRs.

Thus, I=E2=80=99d like to understand the scenarios where the rook orchestra=
tor
module is needed. If there isn=E2=80=99t a need anymore since dashboard
requirements have changed, I=E2=80=99d propose the module can be removed.

Thanks,
Travis
Rook

