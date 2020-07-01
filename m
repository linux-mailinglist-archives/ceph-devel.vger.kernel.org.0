Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2033210130
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 03:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgGABEB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Jun 2020 21:04:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47341 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725805AbgGABEA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Jun 2020 21:04:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593565438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SSjXwwH36l3aVWevcbnjqo3zoFUwjMMHsJ0XDUwNE9E=;
        b=Rb4a56DZznx6Z5Hhn9Nwvq5ykM7r/EwNpOlqV223yDtAPhIbbyLXYHofUME9AcQtiP3kQr
        fDay/UvQ52QhboXxS2TExMavu33aeb6gFhAW/DFvMkqty8d5Ek5kEccS6CIWjPoI4ydLPL
        bmTBnsF2vI5fTEXCM6qdpXiedVgm3XA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-xtyqmsL8NJGox4SBVP0mLw-1; Tue, 30 Jun 2020 21:03:55 -0400
X-MC-Unique: xtyqmsL8NJGox4SBVP0mLw-1
Received: by mail-pl1-f198.google.com with SMTP id q19so13161774pls.7
        for <ceph-devel@vger.kernel.org>; Tue, 30 Jun 2020 18:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SSjXwwH36l3aVWevcbnjqo3zoFUwjMMHsJ0XDUwNE9E=;
        b=r64K+Kc531Dscp2lYycMBoZvg5Uzg02WTl4Zm6ubEeOKh0aY25m9cH5b1DdRB6QpX/
         86tVbuB/QVbVmNTR2o82m1kmV/7ZMBy7rVeooXu8AheGvfRyEpPoH3oktC5gHo7u0tGa
         WOpB712J55Yzvj3B5pRriLDPzZj2yb0OynWU/MRJaKUNTU+38+lZ14TJaI6MuRMLuEKW
         y5mLcCIXDb2MGShe4zC4HLcAf3niukgHEAm8We5oJ4OuRcgS+FJkQevTsfxokFISfIQK
         o2drvQVp6v7isyxEwAyWOgPZUnCPW4+wXv6uYKdb5o3C5vqHODii4L6nDLBsJ+izwvPc
         0CnA==
X-Gm-Message-State: AOAM532oWXB8I2wuILaizE3pE/Zq8WDORRLtAzsNXkNy6zJ0HnUXPQkk
        hP35urnvjfNhkJ0NZVcR42ocSqfxKHN/IlNnwBCgRh2NlzXGY1RWTehaxQSBFztWBh/L1Nldm9R
        7AVGjgvthLKBZVcKf4F7Feg==
X-Received: by 2002:a17:902:e901:: with SMTP id k1mr12786927pld.130.1593565434011;
        Tue, 30 Jun 2020 18:03:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4E4NhxHyt1ODrD/OjkpqGG1mhuccSTepJvomeafPEYpwJaAAdwQkHTtzRDORkpRnRhWq9xg==
X-Received: by 2002:a17:902:e901:: with SMTP id k1mr12786901pld.130.1593565433626;
        Tue, 30 Jun 2020 18:03:53 -0700 (PDT)
Received: from [192.168.0.100] (cpe-104-173-220-126.socal.res.rr.com. [104.173.220.126])
        by smtp.gmail.com with ESMTPSA id w3sm3290069pff.56.2020.06.30.18.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 18:03:52 -0700 (PDT)
Subject: Re: [ceph-users] Re: v15.2.4 Octopus released
To:     Sasha Litvak <alexander.v.litvak@gmail.com>,
        David Galloway <dgallowa@redhat.com>
Cc:     ceph-announce@ceph.io, ceph-users <ceph-users@ceph.io>,
        dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-maintainers@ceph.io
References: <d21c2b58-1191-5e5f-3df1-a84d42750b48@redhat.com>
 <CALi_L4_4ZqX1d7Xa1a8qpRfjHnyvUtj81vr0PGiUE8nmSGwMig@mail.gmail.com>
From:   Dan Mick <dmick@redhat.com>
Message-ID: <0c6fdac1-3ea7-7e73-3a93-73c80de3e93a@redhat.com>
Date:   Tue, 30 Jun 2020 18:03:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALi_L4_4ZqX1d7Xa1a8qpRfjHnyvUtj81vr0PGiUE8nmSGwMig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

True.  That said, the blog post points to 
http://download.ceph.com/tarballs/ where all the tarballs, including 
15.2.4, live.

  On 6/30/2020 5:57 PM, Sasha Litvak wrote:
> David,
> 
> Download link points to 14.2.10 tarball.
> 
> On Tue, Jun 30, 2020, 3:38 PM David Galloway <dgallowa@redhat.com> wrote:
> 
>> We're happy to announce the fourth bugfix release in the Octopus series.
>> In addition to a security fix in RGW, this release brings a range of fixes
>> across all components. We recommend that all Octopus users upgrade to this
>> release. For a detailed release notes with links & changelog please
>> refer to the official blog entry at
>> https://ceph.io/releases/v15-2-4-octopus-released
>>
>> Notable Changes
>> ---------------
>> * CVE-2020-10753: rgw: sanitize newlines in s3 CORSConfiguration's
>> ExposeHeader
>>    (William Bowling, Adam Mohammed, Casey Bodley)
>>
>> * Cephadm: There were a lot of small usability improvements and bug fixes:
>>    * Grafana when deployed by Cephadm now binds to all network interfaces.
>>    * `cephadm check-host` now prints all detected problems at once.
>>    * Cephadm now calls `ceph dashboard set-grafana-api-ssl-verify false`
>>      when generating an SSL certificate for Grafana.
>>    * The Alertmanager is now correctly pointed to the Ceph Dashboard
>>    * `cephadm adopt` now supports adopting an Alertmanager
>>    * `ceph orch ps` now supports filtering by service name
>>    * `ceph orch host ls` now marks hosts as offline, if they are not
>>      accessible.
>>
>> * Cephadm can now deploy NFS Ganesha services. For example, to deploy NFS
>> with
>>    a service id of mynfs, that will use the RADOS pool nfs-ganesha and
>> namespace
>>    nfs-ns::
>>
>>      ceph orch apply nfs mynfs nfs-ganesha nfs-ns
>>
>> * Cephadm: `ceph orch ls --export` now returns all service specifications
>> in
>>    yaml representation that is consumable by `ceph orch apply`. In addition,
>>    the commands `orch ps` and `orch ls` now support `--format yaml` and
>>    `--format json-pretty`.
>>
>> * Cephadm: `ceph orch apply osd` supports a `--preview` flag that prints a
>> preview of
>>    the OSD specification before deploying OSDs. This makes it possible to
>>    verify that the specification is correct, before applying it.
>>
>> * RGW: The `radosgw-admin` sub-commands dealing with orphans --
>>    `radosgw-admin orphans find`, `radosgw-admin orphans finish`, and
>>    `radosgw-admin orphans list-jobs` -- have been deprecated. They have
>>    not been actively maintained and they store intermediate results on
>>    the cluster, which could fill a nearly-full cluster.  They have been
>>    replaced by a tool, currently considered experimental,
>>    `rgw-orphan-list`.
>>
>> * RBD: The name of the rbd pool object that is used to store
>>    rbd trash purge schedule is changed from "rbd_trash_trash_purge_schedule"
>>    to "rbd_trash_purge_schedule". Users that have already started using
>>    `rbd trash purge schedule` functionality and have per pool or namespace
>>    schedules configured should copy "rbd_trash_trash_purge_schedule"
>>    object to "rbd_trash_purge_schedule" before the upgrade and remove
>>    "rbd_trash_purge_schedule" using the following commands in every RBD
>>    pool and namespace where a trash purge schedule was previously
>>    configured::
>>
>>      rados -p <pool-name> [-N namespace] cp rbd_trash_trash_purge_schedule
>> rbd_trash_purge_schedule
>>      rados -p <pool-name> [-N namespace] rm rbd_trash_trash_purge_schedule
>>
>>    or use any other convenient way to restore the schedule after the
>>    upgrade.
>>
>> Getting Ceph
>> ------------
>> * Git at git://github.com/ceph/ceph.git
>> * Tarball at http://download.ceph.com/tarballs/ceph-14.2.10.tar.gz
>> * For packages, see http://docs.ceph.com/docs/master/install/get-packages/
>> * Release git sha1: 7447c15c6ff58d7fce91843b705a268a1917325c
>>
>> --
>> David Galloway
>> Systems Administrator, RDU
>> Ceph Engineering
>> IRC: dgalloway
>> _______________________________________________
>> Dev mailing list -- dev@ceph.io
>> To unsubscribe send an email to dev-leave@ceph.io
>>
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io
> 

