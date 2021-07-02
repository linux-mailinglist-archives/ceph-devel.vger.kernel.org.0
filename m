Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F8A3BA3DB
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 20:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhGBSLF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 14:11:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhGBSLF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 14:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625249312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=04pdwGp2/hw466QmJNbwp04n2DfeMS2PuwrPZuQ/A0M=;
        b=hXFh/y1jSeoUuYVhixWts19VIUFBA5zYSZDHiGyOFvzQ5NLe9GE66akPzskpDPbK4ky7Yl
        7YNQAPox46YN4cfk7OylB2fPwIkzgDvboVAV7jcqpCn7szhYlzF440P7nmrsF0B54IW2Ay
        b4E1toVFwZem9UNYDRcXGcS64Kt+yik=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-dPU6_EfNPxCJOWlwDvb4Ww-1; Fri, 02 Jul 2021 14:08:31 -0400
X-MC-Unique: dPU6_EfNPxCJOWlwDvb4Ww-1
Received: by mail-io1-f69.google.com with SMTP id c5-20020a5ea9050000b02904ed4b46ce62so7389186iod.16
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 11:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=04pdwGp2/hw466QmJNbwp04n2DfeMS2PuwrPZuQ/A0M=;
        b=aDmQDBX8RfCJkChvnzELaqL88MqHcxsP0/8BzpuSWjeUgyusVUFYB5Yc3GWAyv5ONC
         Us4tZH+CkN67BwnPwBtUTJoE+2diFaISGzAFLDU6yfKye7iOSPpJLe2aO7gpX6gcPB+P
         PX5OCFDVhvizsUa2hXW9rw7paQ02PqhZWK8C4NO+OBsWfCqYKD/hJiqhI4VOvjXjBrZK
         D1SqK6FcF0+TOJqdvKKRHQhtoed9+izhsvQi6Qp8kMS9g1bUSRX0H786o56vaIrPstX0
         zsZeAN18LudEJ7UNnagiufJ7FZ1glTIDXn5hWv+4qlNxb/mhmNOzSfn1F3wyhRo+16cT
         0HmQ==
X-Gm-Message-State: AOAM532G83oMSKrk7L3r7e616os1j9lRusIN5Z5beS8DPZftozP7w2Fl
        qgC7I+vAwOJ8xDt5sylHVLqq85BvyZaDMlCXl06fGwST2nmQILFR3S9ZjOYJruPdYm347WDbgsz
        AF8iBbHHWf9SEmNkshaY/4tYayQ7ZTDMwAKVDzw==
X-Received: by 2002:a92:de45:: with SMTP id e5mr815328ilr.157.1625249310584;
        Fri, 02 Jul 2021 11:08:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwSFDBJ0yESEY6HQVOAklDn5RZxHKfxEGyuPQIRhIRs6ldbiql1e1ZmdHB5H9MLdTi2US1TQghtY6E0cnwGJok=
X-Received: by 2002:a92:de45:: with SMTP id e5mr815320ilr.157.1625249310433;
 Fri, 02 Jul 2021 11:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <20210702064821.148063-5-vshankar@redhat.com>
In-Reply-To: <20210702064821.148063-5-vshankar@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 2 Jul 2021 11:08:04 -0700
Message-ID: <CA+2bHPYBetaxkSBUbz-6aNTpbqMYGhHGcCv_ZTiT3GrNZWyLNg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] doc: document new CephFS mount device syntax
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, lhenriques@suse.de,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 1, 2021 at 11:48 PM Venky Shankar <vshankar@redhat.com> wrote:
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  Documentation/filesystems/ceph.rst | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> index 7d2ef4e27273..830ea8969d9d 100644
> --- a/Documentation/filesystems/ceph.rst
> +++ b/Documentation/filesystems/ceph.rst
> @@ -82,7 +82,7 @@ Mount Syntax
>
>  The basic mount syntax is::
>
> - # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
> + # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_addr=monip1[:port][/monip2[:port]]

Somewhat unrelated question to this patchset: can you specify the mons
in the ceph.conf format? i.e. with v2/v1 syntax?

>  You only need to specify a single monitor, as the client will get the
>  full list when it connects.  (However, if the monitor you specify
> @@ -90,16 +90,35 @@ happens to be down, the mount won't succeed.)  The port can be left
>  off if the monitor is using the default.  So if the monitor is at
>  1.2.3.4::
>
> - # mount -t ceph 1.2.3.4:/ /mnt/ceph
> + # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_addr=1.2.3.4
>
>  is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
> -used instead of an IP address.
> +used instead of an IP address and the cluster FSID can be left out
> +(as the mount helper will fill it in by reading the ceph configuration
> +file)::
>
> +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=mon-addr
>
> +Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
> +
> +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=192.168.1.100/192.168.1.101
> +
> +When using the mount helper, monitor address can be read from ceph
> +configuration file if available. Note that, the cluster FSID (passed as part
> +of the device string) is validated by checking it with the FSID reported by
> +the monitor.
>
>  Mount Options
>  =============
>
> +  mon_addr=ip_address[:port][/ip_address[:port]]
> +       Monitor address to the cluster. This is used to bootstrap the
> +        connection to the cluster. Once connection is established, the
> +        monitor addresses in the monitor map are followed.
> +
> +  fsid=cluster-id
> +       FSID of the cluster

Let's note it's the output of `ceph fsid`.

>    ip=A.B.C.D[:N]
>         Specify the IP and/or port the client should bind to locally.
>         There is normally not much reason to do this.  If the IP is not
> --
> 2.27.0
>


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

