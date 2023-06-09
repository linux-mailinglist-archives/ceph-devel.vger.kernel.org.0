Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC513728D62
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 03:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbjFIB6O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 21:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjFIB6M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 21:58:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F5F2D7C
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 18:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686275843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04Zu5Z7OJEa+9A3BruZap5vAuUoQe5F8F8fOhA3/4Ak=;
        b=fXQVA32G/e2fmHghwDJ73H0Tq54T8Dapw1MKXI4XWK697ilOLPByx3hPCHWGXqiczH5Fht
        wacsuphp0dqfSwM8VF25GwOcEy81sl7moX1dKSw/QPrpMJPnS2zjJAFBqTB1y06f3XrsOJ
        oTa+Jc0C1IdDeKUFdVhpzN9bscj5KhI=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-KnauV4jvN62SE8cT3w699Q-1; Thu, 08 Jun 2023 21:57:22 -0400
X-MC-Unique: KnauV4jvN62SE8cT3w699Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2566f2acd88so279646a91.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 18:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686275841; x=1688867841;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04Zu5Z7OJEa+9A3BruZap5vAuUoQe5F8F8fOhA3/4Ak=;
        b=gfHLV2r28klruuDiDQmIR9H4Pll7kpZnts/K6majPUmnSGKObl6vUyWUkuzNuh2NRy
         njSkB+qbjkkVrV1hothPlA4PV7YaDLJ8runl4gwhkOqlBgZj2oQJWuJkFEiFY5THKk74
         JLPsoFOLC2Pe3UtexGidkbLgviYTT9LvFP6y3JaqlbWz8egtOiF4EFvr+59N1b2ot0yR
         I3mnezwuYdNlM6f2z+Mp6ug2FSZfjwVkMc+xTqREcla0jom49XptWcuHWVt1nXupBIbH
         rlkj5nui8+ZYsTD1h3kCqTeA4tD/O7vrRAy5WebxfK4RVY+oXT/61bWfawPlvjGMvGR2
         HGOA==
X-Gm-Message-State: AC+VfDwBebY16LixOBlCtoO3ksa6YZaACpTCn6X8WhY8yci1vS12vZWy
        s4nBrZN95f8kWqdYXkbhwiAT7Aftg25wm+hX4O2kaaVjMJQLBdaLh1OjJIFdDzsdQOom/Uhtiws
        LUzeYBGw2op41oPply1eQzw==
X-Received: by 2002:a17:90a:1999:b0:253:3a2c:df52 with SMTP id 25-20020a17090a199900b002533a2cdf52mr113394pji.39.1686275841672;
        Thu, 08 Jun 2023 18:57:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ74nbreqcgq91AQC1EVQ20zFmvIH4QtWe1bGup4Ixa+ummNsCZv3wYGnyW9l5ZwXgNEhB+VtA==
X-Received: by 2002:a17:90a:1999:b0:253:3a2c:df52 with SMTP id 25-20020a17090a199900b002533a2cdf52mr113385pji.39.1686275841342;
        Thu, 08 Jun 2023 18:57:21 -0700 (PDT)
Received: from [10.72.13.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090a828100b00256504e0937sm3598532pjn.34.2023.06.08.18.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 18:57:20 -0700 (PDT)
Message-ID: <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com>
Date:   Fri, 9 Jun 2023 09:57:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
Content-Language: en-US
To:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/8/23 23:42, Alexander Mikhalitsyn wrote:
> Dear friends,
>
> This patchset was originally developed by Christian Brauner but I'll continue
> to push it forward. Christian allowed me to do that :)
>
> This feature is already actively used/tested with LXD/LXC project.
>
> Git tree (based on https://github.com/ceph/ceph-client.git master):

Could you rebase these patches to 'testing' branch ?

And you still have missed several places, for example the following cases:


    1    269  fs/ceph/addr.c <<ceph_netfs_issue_op_inline>>
              req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, 
mode);
    2    389  fs/ceph/dir.c <<ceph_readdir>>
              req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
    3    789  fs/ceph/dir.c <<ceph_lookup>>
              req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
    ...


For this requests you also need to set the real idmap.


Thanks

- Xiubo



> v5: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v5
> current: https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph
>
> In the version 3 I've changed only two commits:
> - fs: export mnt_idmap_get/mnt_idmap_put
> - ceph: allow idmapped setattr inode op
> and added a new one:
> - ceph: pass idmap to __ceph_setattr
>
> In the version 4 I've reworked the ("ceph: stash idmapping in mdsc request")
> commit. Now we take idmap refcounter just in place where req->r_mnt_idmap
> is filled. It's more safer approach and prevents possible refcounter underflow
> on error paths where __register_request wasn't called but ceph_mdsc_release_request is
> called.
>
> Changelog for version 5:
> - a few commits were squashed into one (as suggested by Xiubo Li)
> - started passing an idmapping everywhere (if possible), so a caller
> UID/GID-s will be mapped almost everywhere (as suggested by Xiubo Li)
>
> I can confirm that this version passes xfstests.
>
> Links to previous versions:
> v1: https://lore.kernel.org/all/20220104140414.155198-1-brauner@kernel.org/
> v2: https://lore.kernel.org/lkml/20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com/
> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v2
> v3: https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com/#t
> v4: https://lore.kernel.org/lkml/20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com/#t
> tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v4
>
> Kind regards,
> Alex
>
> Original description from Christian:
> ========================================================================
> This patch series enables cephfs to support idmapped mounts, i.e. the
> ability to alter ownership information on a per-mount basis.
>
> Container managers such as LXD support sharaing data via cephfs between
> the host and unprivileged containers and between unprivileged containers.
> They may all use different idmappings. Idmapped mounts can be used to
> create mounts with the idmapping used for the container (or a different
> one specific to the use-case).
>
> There are in fact more use-cases such as remapping ownership for
> mountpoints on the host itself to grant or restrict access to different
> users or to make it possible to enforce that programs running as root
> will write with a non-zero {g,u}id to disk.
>
> The patch series is simple overall and few changes are needed to cephfs.
> There is one cephfs specific issue that I would like to discuss and
> solve which I explain in detail in:
>
> [PATCH 02/12] ceph: handle idmapped mounts in create_request_message()
>
> It has to do with how to handle mds serves which have id-based access
> restrictions configured. I would ask you to please take a look at the
> explanation in the aforementioned patch.
>
> The patch series passes the vfs and idmapped mount testsuite as part of
> xfstests. To run it you will need a config like:
>
> [ceph]
> export FSTYP=ceph
> export TEST_DIR=/mnt/test
> export TEST_DEV=10.103.182.10:6789:/
> export TEST_FS_MOUNT_OPTS="-o name=admin,secret=$password
>
> and then simply call
>
> sudo ./check -g idmapped
>
> ========================================================================
>
> Alexander Mikhalitsyn (5):
>    fs: export mnt_idmap_get/mnt_idmap_put
>    ceph: pass idmap to __ceph_setattr
>    ceph: pass idmap to ceph_do_getattr
>    ceph: pass idmap to __ceph_setxattr
>    ceph: pass idmap to ceph_open/ioctl_set_layout
>
> Christian Brauner (9):
>    ceph: stash idmapping in mdsc request
>    ceph: handle idmapped mounts in create_request_message()
>    ceph: pass an idmapping to mknod/symlink/mkdir/rename
>    ceph: allow idmapped getattr inode op
>    ceph: allow idmapped permission inode op
>    ceph: allow idmapped setattr inode op
>    ceph/acl: allow idmapped set_acl inode op
>    ceph/file: allow idmapped atomic_open inode op
>    ceph: allow idmapped mounts
>
>   fs/ceph/acl.c                 |  8 ++++----
>   fs/ceph/addr.c                |  3 ++-
>   fs/ceph/caps.c                |  3 ++-
>   fs/ceph/dir.c                 |  4 ++++
>   fs/ceph/export.c              |  2 +-
>   fs/ceph/file.c                | 21 ++++++++++++++-----
>   fs/ceph/inode.c               | 38 +++++++++++++++++++++--------------
>   fs/ceph/ioctl.c               |  9 +++++++--
>   fs/ceph/mds_client.c          | 27 +++++++++++++++++++++----
>   fs/ceph/mds_client.h          |  1 +
>   fs/ceph/quota.c               |  2 +-
>   fs/ceph/super.c               |  6 +++---
>   fs/ceph/super.h               | 14 ++++++++-----
>   fs/ceph/xattr.c               | 18 +++++++++--------
>   fs/mnt_idmapping.c            |  2 ++
>   include/linux/mnt_idmapping.h |  3 +++
>   16 files changed, 111 insertions(+), 50 deletions(-)
>

