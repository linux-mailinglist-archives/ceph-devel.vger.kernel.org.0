Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C3F3B65C2
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 17:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237118AbhF1Pgj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 11:36:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239012AbhF1Peo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 11:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624894338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGKUsxvovIGUEmbsGDeIYzDdTAF6B2nf43EXOEpdWIg=;
        b=FkUbkjBUeYUjzM31DWwT640jNx867O/GC3wGng0zG33zjM0pyin/2u2GadLQ+iWQiCzUCR
        jHRH3IWctdYv5AtwPhAlEAY22U9M57EU9ucM/vJ5QOHIbnih0faiWzKtZIiUdRbWMONkI/
        7Y5qzERnv7iMJrrRyyOK9yH1fodLZEw=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-LI8DQa38OE-4rwgSy7vwnA-1; Mon, 28 Jun 2021 11:32:16 -0400
X-MC-Unique: LI8DQa38OE-4rwgSy7vwnA-1
Received: by mail-qk1-f199.google.com with SMTP id a2-20020a05620a0662b02903ad3598ec02so11303511qkh.17
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 08:32:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JGKUsxvovIGUEmbsGDeIYzDdTAF6B2nf43EXOEpdWIg=;
        b=Qi+E9jTkpqL9pURUSMjTXY11GbTtCjZhMTEay9DdJRoe3gObyVDCOD/kD5mdnmxino
         31l2k3sgkGi9ng71jD6XJD7nXFfIDWvQLO+w4BTWbdwpSv0tEugJx3+9UFdRIhI+zlHz
         UWR+PU72wmLzeei1+yYGGSkjZI/kLA2UmAEL7ZfD6UIDXPdttinEFYYGUXPAYYbhVtt1
         aB82tIsYyiLNd7U83pCaaLRx6bNcMt0g/uc2b7beouWnpHl7P3SCz9j4rg5K000TS3FU
         lDGFrfc7wvJXkkR86UCcDUYcyafMcAF0jYDFZGJt3tsDdDReuTa+TTVJGgvBmj4pX0ud
         s9gw==
X-Gm-Message-State: AOAM530dS9pF0yICWu0KlYWsUaE8UjtX7OlqODUV5e3k9swgUmgT4P3C
        8qWKT6agzh/p9xN658fywvYG0UkUqI4OT6uatzyvayqyVBiSuG42EK8IYfFgFhP4lHk3LuzURQF
        S8nABnvPEyGXM/RyPWzZhIQ==
X-Received: by 2002:ac8:5ac3:: with SMTP id d3mr19505791qtd.73.1624894336449;
        Mon, 28 Jun 2021 08:32:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYh1ZgRGJyJFt4DOcKtaXy/ZN+DhUzptOViyd98VyFkqodGEEhdA+6mczU4SvUWm1H8ZCThg==
X-Received: by 2002:ac8:5ac3:: with SMTP id d3mr19505774qtd.73.1624894336286;
        Mon, 28 Jun 2021 08:32:16 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id u127sm10830048qkh.120.2021.06.28.08.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 08:32:16 -0700 (PDT)
Message-ID: <e9a13548e835f960f899fe302998c2602c7b1256.camel@redhat.com>
Subject: Re: [PATCH 0/4] ceph: new mount device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 28 Jun 2021 11:32:15 -0400
In-Reply-To: <20210628075545.702106-1-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> This series introduces changes Ceph File System mount device string.
> Old mount device syntax (source) has the following problems:
> 
> mounts to the same cluster but with different fsnames
> and/or creds have identical device string which can
> confuse xfstests.
> 
> Userspace mount helper tool resolves monitor addresses
> and fill in mon addrs automatically, but that means the
> device shown in /proc/mounts is different than what was
> used for mounting.
> 
> New device syntax is as follows:
> 
>   cephuser@fsid.mycephfs2=/path
> 
> Note, there is no "monitor address" in the device string.
> That gets passed in as mount option. This keeps the device
> string same when monitor addresses change (on remounts).
> 
> Also note that the userspace mount helper tool is backward
> compatible. I.e., the mount helper will fallback to using
> old syntax after trying to mount with the new syntax.
> 
> Venky Shankar (4):
>   ceph: new device mount syntax
>   ceph: validate cluster FSID for new device syntax
>   ceph: record updated mon_addr on remount
>   doc: document new CephFS mount device syntax
> 
>  Documentation/filesystems/ceph.rst |  23 ++++-
>  fs/ceph/super.c                    | 132 ++++++++++++++++++++++++++---
>  fs/ceph/super.h                    |   4 +
>  include/linux/ceph/libceph.h       |   1 +
>  net/ceph/ceph_common.c             |   3 +-
>  5 files changed, 149 insertions(+), 14 deletions(-)
> 

Nice work, Venky. It needs a few minor changes, but this looks good
overall. Unless anyone has objections or other suggestions for changes,
we ought to aim to get this into the testing branch soon and aim for
merging it in v5.15.

Thoughts?
-- 
Jeff Layton <jlayton@redhat.com>

