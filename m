Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D93F7FFF
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 03:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhHZBkV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 21:40:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235172AbhHZBkV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 21:40:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629941973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rkEHRR7wNXQQaCMAQeyvBqsvfIXDmrVYIaFSm54b/Ac=;
        b=HguSSWPK549jtbHksntZ0V/EjXsqA5+OTRqV/BCZiLCa0yge4FdRZk6GWZCXhqi5JPZwAH
        gu3KhGbnmYpc6ZZ/OG0Euax4qTJepccoj0kK8VuAuvFTqGlUqPSTOf4kAZlnMMLhcaW9lL
        Eb3tLrxniCkZ5mqbF0/WmntRtkhk2jc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-IUZcbsgRNCqbYj556e1a-g-1; Wed, 25 Aug 2021 21:39:31 -0400
X-MC-Unique: IUZcbsgRNCqbYj556e1a-g-1
Received: by mail-pj1-f70.google.com with SMTP id co10-20020a17090afe8a00b00195640ed21bso349243pjb.3
        for <ceph-devel@vger.kernel.org>; Wed, 25 Aug 2021 18:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rkEHRR7wNXQQaCMAQeyvBqsvfIXDmrVYIaFSm54b/Ac=;
        b=rbLzNow0D8r7jYk9m2qUCP7G+8AtTKvdMNGtePBEzKQhmFBDAI9kuCGeXBqwupxFEh
         H0xeQcDnmESVhnB0c2SXcaBMZQI+6mfbhtMbiT2PnqK56wiWuANvtCiMomq+zvHt/T+4
         sIqMpgpNzE1BgkiV5YF41VcJSXQi7G+swgGmcCPazDzvPJT0tdnjcbKlpbV9mQM7V+RF
         fJ4nmyjzfwmV2eNHaH1zr4MmpKYoFWwGbHfngTXSQecsc/ClvzThqUexP4tkNZJfKS3O
         LHb49LS7lrtotvK3ua7bHcBcatVi0KMMHvsKetnQFByLzGMK92F0oiemjFNIRG/T+V8M
         kUeg==
X-Gm-Message-State: AOAM530/dfz0Elv3I9Qy5iVb3sKSJ/S0jImXylOZn62ATDahhBdsXKw1
        6Cp2KOyYsdN5JDWAnCRPlrrdKapcswMbvJ5swHoyPIwkoyZL36Xx1vXb1l8l7WD7cZG9sqgDu4O
        VlNoK0GmxZuvtq82LDrw1EppmA5BWw9+fn1LzPR4LfodoKWuUHWB/pCSNUNRFt4XJrwSRo/4=
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr1244284plq.59.1629941970466;
        Wed, 25 Aug 2021 18:39:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyec9FQCu9gxbd0bP9eDiOVWPSXyFRLKCMaw8xP+t4SzRszh7iSM2V6TskMAxaQJmisQ7EJVw==
X-Received: by 2002:a17:902:a710:b029:12b:9b9f:c461 with SMTP id w16-20020a170902a710b029012b9b9fc461mr1244257plq.59.1629941970074;
        Wed, 25 Aug 2021 18:39:30 -0700 (PDT)
Received: from [10.72.12.157] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4sm888617pff.126.2021.08.25.18.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 18:39:29 -0700 (PDT)
Subject: Re: [PATCH v3 0/3] ceph: remove the capsnaps when removing the caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20210825134545.117521-1-xiubli@redhat.com>
 <b8e8fb45f9a34dc24b3db66dc26dd55dfb70efd4.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0700a3b1-475e-489d-85f7-b389934b2b57@redhat.com>
Date:   Thu, 26 Aug 2021 09:39:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b8e8fb45f9a34dc24b3db66dc26dd55dfb70efd4.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/26/21 1:16 AM, Jeff Layton wrote:
> On Wed, 2021-08-25 at 21:45 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> V3:
>> - fix one crash bug in the first patch.
>>
>> V2:
>> - minor fixes to clean up the code from Jeff's comments, thanks
>> - swith to use lockdep_assert_held().
>>
>>
>>
>> Test this for around 5 hours and this patch series worked well for me, my test script is:
>>
>> $ while [ 1 ]; do date; for d in A B C; do (for i in {1..3}; do ./bin/mount.ceph :/ /mnt/kcephfs.$d -o noshare; rm -rf /mnt/kcephfs.$d/file$i.txt; rmdir /mnt/kcephfs.$d/.snap/snap$i; dd if=/dev/zero of=/mnt/kcephfs.$d/file$i.txt bs=1M count=8; mkdir -p /mnt/kcephfs.$d/.snap/snap$i; umount -fl /mnt/kcephfs.$d; done ) & done; wait; date; done
>>
>>
>>
>> Xiubo Li (3):
>>    ceph: remove the capsnaps when removing the caps
>>    ceph: don't WARN if we're force umounting
>>    ceph: don't WARN if we're iterate removing the session caps
>>
>>   fs/ceph/caps.c       | 106 ++++++++++++++++++++++++++++++++-----------
>>   fs/ceph/mds_client.c |  40 ++++++++++++++--
>>   fs/ceph/super.h      |   7 +++
>>   3 files changed, 123 insertions(+), 30 deletions(-)
>>
> This looks good overall. I made a small change to the first patch to
> turn the old BUG_ON into a WARN_ON_ONCE. I didn't see the need to crash
> the box in that case.

That looks good to me.


>
> Also, I revised the changelogs and a couple of comments. Let me know if
> you see any issues with the changes I merged into "testing".

This LGTM too.

Thanks Jeff.


>
> Thanks!

