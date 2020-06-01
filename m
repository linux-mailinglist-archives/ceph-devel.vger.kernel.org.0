Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D96F1EB0E5
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jun 2020 23:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFAVX0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jun 2020 17:23:26 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30007 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728182AbgFAVXZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jun 2020 17:23:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591046603;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=bPuHLULMcQosHqouTwKV5RASh9aNjxVsUC//iRwoiU8=;
        b=i4BRUo4LD3lj67jZdV9GFhf0HFBvz1FyCOvlascrkrF5IJrkGZ/jCVNjKkafDxiIW8baod
        sOf5QRlgkxKAn0SrmcJ4FaJZVs7WZDeLWEReDrAcBktBhIYxUK8SrvQ7qKXE8Cycricxvi
        hTr8bOy3epjq+qWsgG1RHDNVWW9l4EA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-a9Cor3SWOpKtyM5HK6ozlA-1; Mon, 01 Jun 2020 17:23:22 -0400
X-MC-Unique: a9Cor3SWOpKtyM5HK6ozlA-1
Received: by mail-wr1-f69.google.com with SMTP id h92so461918wrh.23
        for <ceph-devel@vger.kernel.org>; Mon, 01 Jun 2020 14:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=bPuHLULMcQosHqouTwKV5RASh9aNjxVsUC//iRwoiU8=;
        b=SrZN6++bHGTOUSgT64UELx5skvtAFNOzHLeVhMBeYnRDNPAezCtTRoSRegfQ83iizG
         jrcSz5C/FDfgDX1NweMya0N0ZJvxbThxq97RoL6tA35WjS6ZAcJhSC8Y5HOKUymhpTUO
         JHx7l8EuF2aHzF9nMt94VgOaKTXCOqCyQEtSgR6ZZs4ktK0/Xhw0/MjOLHe8wEBrmqX4
         4zgqFeFrjpNtUlcHYo3SXtr8Fzg1XJMiQT2glqqIGF5bJkbaee0rT/LB+NowUOFx6LRW
         X87hHwM02MCJtKVKsazQgPvKsUrR0dpmDAPXpKfEgwqpfm9K4UCc+0FbJq+gShiXw/lw
         CBmQ==
X-Gm-Message-State: AOAM532MAXJG2Mof41MtPYH0JnO5pWUFnzT5tUu96GP4wwfpEkcJ5D27
        wlMPVqOkvW1Kqe/+UsnuhBCHvuW8kTTndTmyeisZV1FzWvj59Q3YSsbv4xmVFd6koomiJnhuWHR
        irWyY0ZgLhq1sZQDK+JlZIoLLLgBGY9+cQDTC9w==
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr1008198wmb.184.1591046600753;
        Mon, 01 Jun 2020 14:23:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw67QY1UxWDThLmr1enb5ui5ocKMI15wQ1/3HQLEh58cF3scpXIoGxX/min5Ny0xecdXcZWkQzMmbQpcoNNIkA=
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr1008184wmb.184.1591046600504;
 Mon, 01 Jun 2020 14:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200601195826.17159-1-idryomov@gmail.com>
In-Reply-To: <20200601195826.17159-1-idryomov@gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Mon, 1 Jun 2020 17:23:09 -0400
Message-ID: <CA+aFP1Ddw+jWpw187qgOvZRjKfqNGYO6cCwV0pwcqd4BQytY0w@mail.gmail.com>
Subject: Re: [PATCH 0/2] rbd: compression_hint option
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 1, 2020 at 3:58 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> Hello,
>
> This adds support for RADOS compressible/incompressible allocation
> hints, available since Kraken.
>
> Thanks,
>
>                 Ilya
>
>
> Ilya Dryomov (2):
>   libceph: support for alloc hint flags
>   rbd: compression_hint option
>
>  drivers/block/rbd.c             | 44 ++++++++++++++++++++++++++++++++-
>  include/linux/ceph/osd_client.h |  4 ++-
>  include/linux/ceph/rados.h      | 14 +++++++++++
>  net/ceph/osd_client.c           |  8 +++++-
>  4 files changed, 67 insertions(+), 3 deletions(-)
>
> --
> 2.19.2
>

lgtm

Reviewed-by: Jason Dillaman <dillaman@redhat.com>


-- 
Jason

