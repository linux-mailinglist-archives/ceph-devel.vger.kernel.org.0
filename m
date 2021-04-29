Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5033436F30B
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 01:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhD2XrY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Apr 2021 19:47:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229519AbhD2XrW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 19:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619739992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTl9kUvKJMfVYe7OqtQ5Orf5C8b6JD5j9im5kGAnETw=;
        b=FHhP6iSxNR4F9q2l0dcLkckXeZXpnuQDuZZftezHfwfd0CImHCDTFsPYUj/pDMrpHiEIhW
        NHh0vDDTyrfhe5Jj+LsNmm/QnpP5sRF5MNjlI9sxC+0m9vxX8rCUr/l8Tipn40CAHF5lA7
        zNvkotCRksPdHNMXq9R6r0lxyM9ivio=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-KN-wgEIrMeedLhUyGhsRCA-1; Thu, 29 Apr 2021 19:46:28 -0400
X-MC-Unique: KN-wgEIrMeedLhUyGhsRCA-1
Received: by mail-pj1-f72.google.com with SMTP id i10-20020a17090a650ab0290155f6f011a9so743139pjj.0
        for <ceph-devel@vger.kernel.org>; Thu, 29 Apr 2021 16:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTl9kUvKJMfVYe7OqtQ5Orf5C8b6JD5j9im5kGAnETw=;
        b=Jc59HZmzr6VsM+1skZOM72PBeZNfGtCBjozKrIZQN+FLPlkfUgxli1K1c4G/NKVQpi
         V4ZBQeSb3Ux6KUtYVJvUgwS/kQPWsp/E/XyS9CaTRXC8jg1GhGRFMTojfvpHhsRy0GiY
         kbFM9pzoH8R4KOypLjEKdmCmpBZAFTIU0oHTnnDJp294QcitZ5eslTP+xMvSEx3K4h/q
         ZQWpzcks16qW6zM9EEXY7zV70Ffi5qlf0dKI1dEJ9oIdp9R1nvUyCiZSibmfjaoNIaYU
         QTBFrN2IApDRR5eLeofBpfVqHz7FrnTsJDbtakjRN3zpcnfNsSOrsJBdDNM4uGVzmGnG
         GTiw==
X-Gm-Message-State: AOAM5317VJVL07iELCk8CqJUSoNmkW67vr1hzccLFNwa1wK5BbuEho4n
        xQ36oLwcBc5roa4Ibf9S/k9G+Bt1suphLCm/qIvouHDEyROHmhMcS+oLSI7NRuBqcNbQRLrmBi6
        AWi18p5GxNE78SAXEX1NGrcG2pggoTRATGDL19w==
X-Received: by 2002:a17:90b:31cc:: with SMTP id jv12mr12356047pjb.105.1619739987199;
        Thu, 29 Apr 2021 16:46:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyyuNMv6xrzQVXRD9xqaX4TE4xu5GTpGhHjeF6ekbaJ4oGYyHyUafA2xdF3N+c7ufxkLdDZcH6iRyV4lvp0JQ=
X-Received: by 2002:a17:90b:31cc:: with SMTP id jv12mr12356026pjb.105.1619739986945;
 Thu, 29 Apr 2021 16:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
In-Reply-To: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 29 Apr 2021 16:46:01 -0700
Message-ID: <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
Subject: Re: ceph-mds infrastructure for fscrypt
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

On Thu, Apr 22, 2021 at 11:19 AM Jeff Layton <jlayton@redhat.com> wrote:
> At this point, I'm thinking it might be best to unify all of the
> per-inode info into a single field that the MDS would treat as opaque.
> Note that the alternate_names feature would remain more or less
> untouched since it's associated more with dentries than inodes.
>
> The initial version of this field would look something like this:
>
> struct ceph_fscrypt_context {
>         u8                              version;        // == 1
>         struct fscrypt_context_v2       fscrypt_ctx;    // 40 bytes
>         __le32                          blocksize       // 4k for now
>         __le64                          size;           // "real"
> i_size
> };
>
> The MDS would send this along with any size updates (InodeStat, and
> MClientCaps replies). The client would need to send this in cap
> flushes/updates, and we'd also need to extend the SETATTR op too, so the
> client can update this field in truncates (at least).
>
> I don't look forward to having to plumb this into all of the different
> client ops that can create inodes though. What I'm thinking we might
> want to do is expose this field as the "ceph.fscrypt" vxattr.

I think the process for adding the fscrypt bits to the MClientRequest
will be the same as adding alternate_name? In the
ceph_mds_request_head payload. I don't like the idea of stuffing this
data in the xattr map.

> The client can stuff that into the xattr blob when creating a new inode,
> and the MDS can scrape it out of that and move the data into the correct
> field in the inode. A setxattr on this field would update the new field
> too. It's an ugly interface, but shouldn't be too bad to handle and we
> have some precedent for this sort of thing.
>
> The rules for handling the new field in the client would be a bit weird
> though. We'll need to allow it to reading the fscrypt_ctx part without
> any caps (since that should be static once it's set), but the size
> handling needs to be under the same caps as the traditional size field
> (Is that Fsx? The rules for this are never quite clear to me.)
>
> Would it be better to have two different fields here -- fscrypt_auth and
> fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> need to keep all of this info together, but it seemed neater that way.

I'm not seeing a reason to split the struct.

> Thoughts? Opinions? Is this a horrible idea? What would be better?
>
> Thanks,
> --
> Jeff Layton <jlayton@redhat.com>
>
> [1]: latest draft was posted here:
> https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#t
> [2]: https://github.com/ceph/ceph/pull/37297
> [3]:
> https://github.com/ceph/ceph/commit/7fe1c57846a42443f0258fd877d7166f33fd596f
> [4]:
> https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
>
>


-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

