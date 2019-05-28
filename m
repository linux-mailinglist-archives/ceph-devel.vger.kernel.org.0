Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B05652C373
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 11:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfE1Jnv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 05:43:51 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:52849 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfE1Jnv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 05:43:51 -0400
Received: by mail-it1-f173.google.com with SMTP id t184so3223259itf.2
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AMZlbHsWBLGsa4+3CIrNgYVb3FtrUbWyLscZdLdfwP8=;
        b=jjxY7cOIFNp0ZGdLAouDtxKF8KTeNLyJBWFNvURl2E/vGRHYuTuCF2Iu2jonSAhHG6
         pnSJRF+RoZYhgmPiqqdu2W8EjILHC0fZtbLrx35LdEggAyAYVZWJi9K8redj9RPeIFzQ
         tnPKC+0swSPGQsjt3KWORabyB1BDPsgo4VLhMAGkhsb/kTfT8A4F3urgZ6m0KKUnlM4I
         DPOnC2R4O323X3pGPyhDACpv8JJPQwyxyDiwMklWI3lY5+2/qMfvncn3H2fafJyOuLI+
         aVwt9ONyjDWEVUaSIjve81udBs5ak8m9dEwdOgDalcmRDm53yZaiZHP7gFslhjG24sam
         w+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AMZlbHsWBLGsa4+3CIrNgYVb3FtrUbWyLscZdLdfwP8=;
        b=YexPP1ZvFQEl88qNuJsTGk+qQlvdmRe2M+db7EQYhZJu/m2mUI80g0akjCW4SW0tWG
         KVRmVQB3DIygrVbqsBD3r22zDae6fJ07ixX1AI6XA5o9TSHYoJl5npUt8hoO/c3PZgL4
         WPrL7xtu8xEK2GSOSFcJrzvGBImGDlODQKumsRCDjp4ctCrLlrTMCuAfDSlAh54M8/c7
         zRgPPQGOMs8yXfnZQZvHjSRbSwOJRd12fsnHMPN8k6zcUr8MXHmAMypHdtzrVZFZA1KN
         4Xfmbmx/TiVWDOtJP1xvua+DwaKuNjB1dZcS1Mz8L81az/M2i6kRYhcqvQ3fSETuSlbz
         fGLg==
X-Gm-Message-State: APjAAAVBL5tNOxztTiJAkTUneivX0Rks9L9BYmK1C1ED2i0SdUcqbOs0
        l30TgbUfuIAJv4srQfGbxj8HFu6uW7kd8t8dQEycjxwLvM0=
X-Google-Smtp-Source: APXvYqwvdDFedao9S1OUVU8HAM0mAw3F1xbw1WHhnYG4U4fc9eIThrv1QJW4DJULtPJGnjzZOoxj+yXyWeb23d952TM=
X-Received: by 2002:a24:2f10:: with SMTP id j16mr2269502itj.75.1559036630308;
 Tue, 28 May 2019 02:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAEYCsVJ_k_HxRFxts_Vbk8KN8GQ73Kh_JBKf4upE46YrfHGnbA@mail.gmail.com>
 <349539bb-bbf2-e900-2972-bd309f2d4fa1@redhat.com>
In-Reply-To: <349539bb-bbf2-e900-2972-bd309f2d4fa1@redhat.com>
From:   Xiaoxi Chen <superdebuger@gmail.com>
Date:   Tue, 28 May 2019 17:43:38 +0800
Message-ID: <CAEYCsVJBdy1RW-67ADZBx3t4G+_+qJYSVAZAYC9ZpGmjfhA5VQ@mail.gmail.com>
Subject: Re: Multisite sync corruption for large multipart obj
To:     Casey Bodley <cbodley@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Casey,
    Thanks for the reply.   I couldnt find the log back to that time
due to logroate remove anything older than 7 days...sorry for that.

    It looks to me like the issue was trigger by restart/failure on
src_zone rgw, which cause connection reset in our http client however
the error is not popping up to upper layer. Then we finished out the
object and adding metadata as-is.  The detecting we are missing in
this case is the integrity of src obj.  As we lost the multipart
information we cannot use ETAG to check the integrity for fetched obj.
Maybe  a simple size check can help us to some extent as the first
step (truncate is much more often than corruption as restart of RGW
can easily trigger the issue) , very weak but better than none...

     The STREAMING-AWS4-HMAC-SHA256-PAYLOAD it seems more for ensuring
the data integrity for putObj progress, but we are uploading through
rados, not sure how can we get use of this?

      Is there any possibility that we expose the multipart
information(including part size, checksum of each part, as well as
ETAG) from src zone though internal API? so that in
RGWRados::fetch_remote_obj we can keep the multipart format and do
integrity check?

-Xiaoxi

Casey Bodley <cbodley@redhat.com> =E4=BA=8E2019=E5=B9=B45=E6=9C=8824=E6=97=
=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=884:15=E5=86=99=E9=81=93=EF=BC=9A

>
>
> On 5/21/19 9:16 PM, Xiaoxi Chen wrote:
> > we have a two-zone multi-site setup, zone lvs and zone slc
> > respectively. It works fine in general however we got reports from
> > customer about data corruption/mismatch between two zone
> >
> > root@host:~# s3cmd -c .s3cfg_lvs ls
> > s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> > 2019-05-14 04:30 410444223 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5=
KS/index
> > root@host-ump:~# s3cmd -c .s3cfg_slc ls
> > s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> > 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5K=
S/index
> >
> > Object metadata in SLC/LVS can be found in
> > https://pastebin.com/a5JNb9vb LVS
> > https://pastebin.com/1MuPJ0k1 SLC
> >
> > SLC is a single flat object while LVS is a multi-part object, which
> > indicate the object was uploaded by user in LVS and mirrored to
> > SLC.The SLC object get truncated after 62158776, the first 62158776
> > bytes are right.
> >
> > root@host:~# cmp -l slc_obj lvs_obj
> > cmp: EOF on slc_obj after byte 62158776
> >
> > Both bucket sync status and overall sync status shows positive, and
> > the obj was created 5 days ago. It sounds more like when pulling the
> > object content from source zone(LVS), the transaction was terminated
> > somewhere in between and cause an incomplete obj, and seems we dont
> > have checksum verification in sync_agent so that the corrupted obj was
> > there and be treated as a success sync.
> It's troubling to see that sync isn't detecting an error from the
> transfer. Do you see any errors from the http client in your logs such
> as 'WARNING: client->receive_data() returned ret=3D'?
>
> I agree that we need integrity checking, but we can't rely on ETags
> because of the way that multipart objects sync as non-multipart. I think
> the right way to address this is to add v4 signature support to the http
> client, and rely on STREAMING-AWS4-HMAC-SHA256-PAYLOAD for integrity of
> the body chunks
> (https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-streaming.html).
>
> >
> > root@host:~# radosgw-admin --cluster slc_ceph_ump bucket sync status
> > --bucket=3Dms-nsn-prod-48
> > realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
> > zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
> > zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
> > bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
> >
> > source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
> >                  full sync: 0/16 shards
> >                  incremental sync: 16/16 shards
> >                  bucket is caught up with source
> >
> >
> > Re-sync on the bucket will not solve the inconsistency
> Right. The GET requests that fetch objects use the If-Modified-Since
> header to avoid transferring data unless the mtime has changed. In order
> to force re-sync, you would have to do something that updates its mtime
> - for example, setting an acl.
> > radosgw-admin bucket sync init --source-zone lvs --bucket=3Dms-nsn-prod=
-48
> >
> > root@host:~# radosgw-admin bucket sync status --bucket=3Dms-nsn-prod-48
> > realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
> > zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
> > zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
> > bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
> >
> > source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
> >                  full sync: 0/16 shards
> >                  incremental sync: 16/16 shards
> >                  bucket is caught up with source
> >
> > root@lvscephmon01-ump:~# s3cmd -c .s3cfg_slc ls
> > s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> > 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5K=
S/index
> >
> >
> > A tracker was submitted to
> > https://tracker.ceph.com/issues/39992
>
