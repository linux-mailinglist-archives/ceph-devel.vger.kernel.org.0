Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC560C954
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Oct 2022 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiJYKEI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Oct 2022 06:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbiJYKDf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Oct 2022 06:03:35 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C94FC6E4
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 02:58:12 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ud5so7554884ejc.4
        for <ceph-devel@vger.kernel.org>; Tue, 25 Oct 2022 02:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oKIZ6XLNNrcediyAjLcdXx1DLwHh7OZ4VfOaL18dLfo=;
        b=C4/K2Gv/LJoyjJkov3KuVi/VlaLlQEOp8OWpxO66frJzThdTchoi3MmoAWQNX0Sf/3
         p5yo6IFCKapotwuxuM+QdvqOFfBgDaVJ6iw5OsIs5uFyexpXTvmqnqDSDT9vfQUD7Zk0
         EgwVIZv8phbmIGD6Gi++YygMZvn5OHf2Z3Dv8ysW1BL+VsgrBwgwaE1Kd2nNV/hj7oN4
         ESQu/suWBZTyfYIP3q9UblpB+v71DcFxKpi7kn2x8+ZAJDKY3bAZfKu4s2My+bYVuy+l
         RF18z1omwNN4mFknRdpkmSDC3barO69SIyywddsODmxU8jaVtLJZT82TFOwwKCu1e8Lh
         4tmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oKIZ6XLNNrcediyAjLcdXx1DLwHh7OZ4VfOaL18dLfo=;
        b=PgHpL//nAW2BmzdCTGf2rlWlHAJbwLkOjeSbdkDMntoSyfkSXU+JNRVEjwfgLqAdlW
         BvNpFr68WEn9aeS1S43wdNc+XYbV6YPVKae+8zf+ZpgbVSX2QlK8vSgqi4jNdSMz82aG
         u1uxa5+8w/yROro0akK2HqbNgmcil4IfruXoR2arsFB2vd/yqqW9i0ASOleJtfzeIPn+
         hrMz4w/pxPBuXSRWq7pOMfGLZpMskzs+Kp58GV2384t5TuzRzbxUOaSp2PfM5xFQ7st5
         gDQZ9GYQmiyfi0S1kB/7LGPX50updKRESa45EHg5ztWY/0EVSrzpDFKtWKxa7ZAMMZWm
         lS9g==
X-Gm-Message-State: ACrzQf13fJsi6CAgTHTbcM0qSYD1141Bhc6zY8DNoPKnumBHm5bgQ/c7
        8lzbJAUoyFL+7nMO+HWPKbkQLExt+mLWS9g8Xs0F2w==
X-Google-Smtp-Source: AMsMyM6Mvrp7DAcqS7eOdbD71753mmAZ5MykIIvTZQOdr2iQrdej82vku+QUBM27HIlzbIUVs0twQZu42JFb5ECZ9PM=
X-Received: by 2002:a17:906:cc18:b0:78d:ee0f:ce02 with SMTP id
 ml24-20020a170906cc1800b0078dee0fce02mr32019065ejb.323.1666691890969; Tue, 25
 Oct 2022 02:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220927120857.639461-1-max.kellermann@ionos.com>
 <88f8941f-82bf-5152-b49a-56cb2e465abb@redhat.com> <CAKPOu+88FT1SeFDhvnD_NC7aEJBxd=-T99w67mA-s4SXQXjQNw@mail.gmail.com>
 <75e7f676-8c85-af0a-97b2-43664f60c811@redhat.com> <CAKPOu+-rKOVsZ1T=1X-T-Y5Fe1MW2Fs9ixQh8rgq3S9shi8Thw@mail.gmail.com>
 <baf42d14-9bc8-93e1-3d75-7248f93afbd2@redhat.com> <cd5ed50a3c760f746a43f8d68fdbc69b01b89b39.camel@kernel.org>
 <7e28f7d1-cfd5-642a-dd4e-ab521885187c@redhat.com> <8ef79208adc82b546cc4c2ba20b5c6ddbc3a2732.camel@kernel.org>
 <7d40fada-f5f8-4357-c559-18421266f5b4@redhat.com> <CAKPOu+_Jk0EHRDjqiNuFv8wL0kLXLLRZpx7AgWDPOWHzJn22xg@mail.gmail.com>
 <db650fa8-8b64-5275-7390-f6b48bfd3a37@redhat.com>
In-Reply-To: <db650fa8-8b64-5275-7390-f6b48bfd3a37@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Tue, 25 Oct 2022 11:57:59 +0200
Message-ID: <CAKPOu+8qd+qybZWOMoaAYzOtTWXEQ=y5q1jJZjOVxE8pwX7CkQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/super: add mount options "snapdir{mode,uid,gid}"
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 25, 2022 at 11:10 AM Xiubo Li <xiubli@redhat.com> wrote:
> $ sudo ./bin/mount.ceph privileged@.a=/ /mnt/privileged/mountpoint
>
> $ sudo ./bin/mount.ceph global@.a=/ /mnt/global/mountpoint

So you have two different mount points where different client
permissions are used. There are various problems with that
architecture:

- it complicates administration, because now every mount has to be done twice
- it complicates applications accessing ceph (and their
configuration), because there are now 2 mount points
- it increases resource usage for having twice as many ceph connections
- it interferes with fscache, doubling fscache's local disk usage,
reducing fscache's efficiency
- ownership of the snapdir is still the same as the parent directory,
and I can't have non-superuser processes to manage snapshots; all
processes mananging snapshots need to have write permission on the
parent directory
- this is still all-or-nothing; I can't forbid users to list (+r) or
access (+x) snapshots

All those problems don't exist with my patch.
