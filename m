Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99652135AC9
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgAIN6N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:58:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbgAIN6N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jan 2020 08:58:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578578292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wvVLu2EtZcrMN2nentqoeS9d6XOrn+5p1ZsYIDBWZc8=;
        b=J3pd9vSjl8KipwjbkbM7b3imr8uk7f00J/v0gYd6JuGAn7IwqMZ0nnIztMTWQtxKT2ZJ/9
        OdR6FG3oZqkvfuthpQpsGL14i3kkjxYHfJLzYRjCALXQNQ4P2b2vbCcm2kN0jS10BcZgyV
        RFxDobhSfMRmq7XbIzrgf6ldwTF1+EU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-SWLUyM40N_SV4lCPepdXsw-1; Thu, 09 Jan 2020 08:58:11 -0500
X-MC-Unique: SWLUyM40N_SV4lCPepdXsw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F8B6107ACCA;
        Thu,  9 Jan 2020 13:58:10 +0000 (UTC)
Received: from [10.72.12.239] (ovpn-12-239.pek2.redhat.com [10.72.12.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5E225E240;
        Thu,  9 Jan 2020 13:58:05 +0000 (UTC)
Subject: Re: [PATCH 0/6] ceph: asynchronous unlink support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com
References: <20200106153520.307523-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <85503b6d-4340-744d-395a-5eefc3a2914c@redhat.com>
Date:   Thu, 9 Jan 2020 21:58:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/6/20 11:35 PM, Jeff Layton wrote:
> I sent an initial RFC set for this around 10 months ago. Since then,
> the requisite patches for the MDS have been merged for the octopus
> release. This adds support to the kclient to take advantage of
> asynchronous unlinks.
> 
> In earlier testing (with a vstart cluster backed by a rotating HDD), I
> saw roughly a 2x speedup when doing an rmdir on a directory with 10000
> files in it. When testing with a cluster backed by an NVMe SSD though,
> I only saw about a 20% speedup.
> 
> I'd like to put this in the testing branch now, so that it's ready for
> merge in the upcoming v5.6 merge window. Once this is in, asynchronous
> create support will be the next step.
> 
> Jeff Layton (4):
>    ceph: close holes in struct ceph_mds_session
>    ceph: hold extra reference to r_parent over life of request
>    ceph: register MDS request with dir inode from the start
>    ceph: add refcounting for Fx caps
> 
> Yan, Zheng (2):
>    ceph: check inode type for CEPH_CAP_FILE_{CACHE,RD,REXTEND,LAZYIO}
>    ceph: perform asynchronous unlink if we have sufficient caps
> 
>   fs/ceph/caps.c               | 84 ++++++++++++++++++++++++++----------
>   fs/ceph/dir.c                | 70 ++++++++++++++++++++++++++++--
>   fs/ceph/inode.c              |  9 +++-
>   fs/ceph/mds_client.c         | 27 ++++++------
>   fs/ceph/mds_client.h         |  2 +-
>   fs/ceph/super.c              |  4 ++
>   fs/ceph/super.h              | 17 +++-----
>   include/linux/ceph/ceph_fs.h |  9 ++++
>   8 files changed, 169 insertions(+), 53 deletions(-)
> 

Series Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

