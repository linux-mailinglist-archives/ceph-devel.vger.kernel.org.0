Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8996F210142
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 03:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgGABHV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 21:07:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGABHU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 21:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593565638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=po+ER4ClKBfsZnSK1Z3VHP7srwtKHt7ih/TqCwWJyPU=;
        b=H0+mM9IA7uAnmvk4UE1fkFutjJpSiAYnsDwV6M159pWntC76HclxoOz3g1sg/Q4kCP9w+Q
        X8OJgO3Wdayo+G10cUvRrcjBUlbczMdlOqqv5sDAuZr0zbhLvX2v9DFhRy+6TwkB9M4XDR
        afapp4+5SgY00bKUQCyBrH/e3dVeU4o=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-cnYMTtp5PR6htjtAqakEVQ-1; Tue, 30 Jun 2020 21:06:52 -0400
X-MC-Unique: cnYMTtp5PR6htjtAqakEVQ-1
Received: by mail-qt1-f198.google.com with SMTP id c22so15741383qtp.9
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jun 2020 18:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=po+ER4ClKBfsZnSK1Z3VHP7srwtKHt7ih/TqCwWJyPU=;
        b=p4BbS5wawmxed6hTzIXqIlO3wLDHtyIIaQ9qPm/8bSaOxHiHZJvCTuosR6vznkUlIq
         cjiu5j0zvPLAW2LbsPxdaiZVDjgQMStqje1JUsoSpl2jY4aXYkT5JOft3giO5tXGNIHv
         7iZOMW0SYS2NIZeBjeN1tCzjKHKoRwyUOrlwWxKz/AYvIixk3uib0Zsa63OYS3M4rdQd
         tyhxirDuhDL+zJEgSSw8ajOiE8JHudOtWyJAN4S4k174m+dlknDGfBhv733n/FJpL5Nw
         QWeIYfXFpSbnn+WPnA1AxsgXypNWAriocwyea+DIWVjxMAmdqdA1MXTSiihfmZyOBGqL
         +PbA==
X-Gm-Message-State: AOAM532QDI+86USqYckdXZDSbnmWtipBUhqESI2A0t8jPFab1F2UPgAD
        Rv8e0EuPQOQdQiRPOL63cJLz+eUuMw1a3MqIT7A9O59F2IlRzkDOtW7bGNUCvkGDGgFt59iXhfQ
        V5n7FX9+nl4IqZjn51dp2sGu6nYKrmYWrapJ/mg==
X-Received: by 2002:ac8:18a5:: with SMTP id s34mr22899301qtj.210.1593565612245;
        Tue, 30 Jun 2020 18:06:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1F9dfJkhFjofeRYJY9aM6CWzAlHP3qnomcys7NfhG9nMgKHgj30kzPgnfFg8rQ+AINgX6XV7mwihK6T4GfFM=
X-Received: by 2002:ac8:18a5:: with SMTP id s34mr22899275qtj.210.1593565611928;
 Tue, 30 Jun 2020 18:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
 <CALi_L4_4ZqX1d7Xa1a8qpRfjHnyvUtj81vr0PGiUE8nmSGwMig@mail.gmail.com> <0c6fdac1-3ea7-7e73-3a93-73c80de3e93a@redhat.com>
In-Reply-To: <0c6fdac1-3ea7-7e73-3a93-73c80de3e93a@redhat.com>
From:   Neha Ojha <nojha@redhat.com>
Date:   Tue, 30 Jun 2020 18:06:41 -0700
Message-ID: <CAKn7kBk90XSUPpvkeT2UnW4pzJxS6bhifLWOmcrT9MENkJGgRQ@mail.gmail.com>
Subject: Re: [ceph-users] Re: v15.2.4 Octopus released
To:     Dan Mick <dmick@redhat.com>
Cc:     Sasha Litvak <alexander.v.litvak@gmail.com>,
        David Galloway <dgallowa@redhat.com>, ceph-announce@ceph.io,
        ceph-users <ceph-users@ceph.io>, dev <dev@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>, ceph-maintainers@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 30, 2020 at 6:04 PM Dan Mick <dmick@redhat.com> wrote:
>
> True.  That said, the blog post points to
> http://download.ceph.com/tarballs/ where all the tarballs, including
> 15.2.4, live.
>
>   On 6/30/2020 5:57 PM, Sasha Litvak wrote:
> > David,
> >
> > Download link points to 14.2.10 tarball.
> >
> > On Tue, Jun 30, 2020, 3:38 PM David Galloway <dgallowa@redhat.com> wrote:
> >
> >> We're happy to announce the fourth bugfix release in the Octopus series.
> >> In addition to a security fix in RGW, this release brings a range of fixes
> >> across all components. We recommend that all Octopus users upgrade to this
> >> release. For a detailed release notes with links & changelog please
> >> refer to the official blog entry at
> >> https://ceph.io/releases/v15-2-4-octopus-released
> >>
> >> Notable Changes
> >> ---------------
> >> * CVE-2020-10753: rgw: sanitize newlines in s3 CORSConfiguration's
> >> ExposeHeader
> >>    (William Bowling, Adam Mohammed, Casey Bodley)
> >>
> >> * Cephadm: There were a lot of small usability improvements and bug fixes:
> >>    * Grafana when deployed by Cephadm now binds to all network interfaces.
> >>    * `cephadm check-host` now prints all detected problems at once.
> >>    * Cephadm now calls `ceph dashboard set-grafana-api-ssl-verify false`
> >>      when generating an SSL certificate for Grafana.
> >>    * The Alertmanager is now correctly pointed to the Ceph Dashboard
> >>    * `cephadm adopt` now supports adopting an Alertmanager
> >>    * `ceph orch ps` now supports filtering by service name
> >>    * `ceph orch host ls` now marks hosts as offline, if they are not
> >>      accessible.
> >>
> >> * Cephadm can now deploy NFS Ganesha services. For example, to deploy NFS
> >> with
> >>    a service id of mynfs, that will use the RADOS pool nfs-ganesha and
> >> namespace
> >>    nfs-ns::
> >>
> >>      ceph orch apply nfs mynfs nfs-ganesha nfs-ns
> >>
> >> * Cephadm: `ceph orch ls --export` now returns all service specifications
> >> in
> >>    yaml representation that is consumable by `ceph orch apply`. In addition,
> >>    the commands `orch ps` and `orch ls` now support `--format yaml` and
> >>    `--format json-pretty`.
> >>
> >> * Cephadm: `ceph orch apply osd` supports a `--preview` flag that prints a
> >> preview of
> >>    the OSD specification before deploying OSDs. This makes it possible to
> >>    verify that the specification is correct, before applying it.
> >>
> >> * RGW: The `radosgw-admin` sub-commands dealing with orphans --
> >>    `radosgw-admin orphans find`, `radosgw-admin orphans finish`, and
> >>    `radosgw-admin orphans list-jobs` -- have been deprecated. They have
> >>    not been actively maintained and they store intermediate results on
> >>    the cluster, which could fill a nearly-full cluster.  They have been
> >>    replaced by a tool, currently considered experimental,
> >>    `rgw-orphan-list`.
> >>
> >> * RBD: The name of the rbd pool object that is used to store
> >>    rbd trash purge schedule is changed from "rbd_trash_trash_purge_schedule"
> >>    to "rbd_trash_purge_schedule". Users that have already started using
> >>    `rbd trash purge schedule` functionality and have per pool or namespace
> >>    schedules configured should copy "rbd_trash_trash_purge_schedule"
> >>    object to "rbd_trash_purge_schedule" before the upgrade and remove
> >>    "rbd_trash_purge_schedule" using the following commands in every RBD
> >>    pool and namespace where a trash purge schedule was previously
> >>    configured::
> >>
> >>      rados -p <pool-name> [-N namespace] cp rbd_trash_trash_purge_schedule
> >> rbd_trash_purge_schedule
> >>      rados -p <pool-name> [-N namespace] rm rbd_trash_trash_purge_schedule
> >>
> >>    or use any other convenient way to restore the schedule after the
> >>    upgrade.
> >>
> >> Getting Ceph
> >> ------------
> >> * Git at git://github.com/ceph/ceph.git

Correction:
* Tarball at http://download.ceph.com/tarballs/ceph-15.2.4.tar.gz

> >> * For packages, see http://docs.ceph.com/docs/master/install/get-packages/
> >> * Release git sha1: 7447c15c6ff58d7fce91843b705a268a1917325c
> >>
> >> --
> >> David Galloway
> >> Systems Administrator, RDU
> >> Ceph Engineering
> >> IRC: dgalloway
> >> _______________________________________________
> >> Dev mailing list -- dev@ceph.io
> >> To unsubscribe send an email to dev-leave@ceph.io
> >>
> > _______________________________________________
> > ceph-users mailing list -- ceph-users@ceph.io
> > To unsubscribe send an email to ceph-users-leave@ceph.io
> >
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io
>

