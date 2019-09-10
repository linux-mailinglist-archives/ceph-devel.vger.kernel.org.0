Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E65AE892
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfIJKpp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 06:45:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:39996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728238AbfIJKpp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 06:45:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1A64B684;
        Tue, 10 Sep 2019 10:45:42 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     IlyaDryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>,
        Sage Weil <sage@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ceph: allow object copies across different filesystems in the same cluster
References: <87k1ahojri.fsf@suse.com>
        <20190909102834.16246-1-lhenriques@suse.com>
        <3f838e42a50575595c7310386cf698aca8f89607.camel@kernel.org>
        <87d0g9oh4r.fsf@suse.com>
        <CAJ4mKGZVjJxQA69s92C+7DFbDxv87SOj10AUfyLXwVe9b+SDTw@mail.gmail.com>
Date:   Tue, 10 Sep 2019 11:45:41 +0100
In-Reply-To: <CAJ4mKGZVjJxQA69s92C+7DFbDxv87SOj10AUfyLXwVe9b+SDTw@mail.gmail.com>
        (Gregory Farnum's message of "Mon, 9 Sep 2019 15:22:10 -0700")
Message-ID: <871rwoo2ei.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Gregory Farnum <gfarnum@redhat.com> writes:

> On Mon, Sep 9, 2019 at 4:15 AM Luis Henriques <lhenriques@suse.com> wrote:
>>
>> "Jeff Layton" <jlayton@kernel.org> writes:
>>
>> > On Mon, 2019-09-09 at 11:28 +0100, Luis Henriques wrote:
>> >> OSDs are able to perform object copies across different pools.  Thus,
>> >> there's no need to prevent copy_file_range from doing remote copies if the
>> >> source and destination superblocks are different.  Only return -EXDEV if
>> >> they have different fsid (the cluster ID).
>> >>
>> >> Signed-off-by: Luis Henriques <lhenriques@suse.com>
>> >> ---
>> >>  fs/ceph/file.c | 18 ++++++++++++++----
>> >>  1 file changed, 14 insertions(+), 4 deletions(-)
>> >>
>> >> Hi,
>> >>
>> >> Here's the patch changelog since initial submittion:
>> >>
>> >> - Dropped have_fsid checks on client structs
>> >> - Use %pU to print the fsid instead of raw hex strings (%*ph)
>> >> - Fixed 'To:' field in email so that this time the patch hits vger
>> >>
>> >> Cheers,
>> >> --
>> >> Luis
>> >>
>> >> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> >> index 685a03cc4b77..4a624a1dd0bb 100644
>> >> --- a/fs/ceph/file.c
>> >> +++ b/fs/ceph/file.c
>> >> @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >>      struct ceph_inode_info *src_ci = ceph_inode(src_inode);
>> >>      struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>> >>      struct ceph_cap_flush *prealloc_cf;
>> >> +    struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>> >>      struct ceph_object_locator src_oloc, dst_oloc;
>> >>      struct ceph_object_id src_oid, dst_oid;
>> >>      loff_t endoff = 0, size;
>> >> @@ -1915,8 +1916,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >>
>> >>      if (src_inode == dst_inode)
>> >>              return -EINVAL;
>> >> -    if (src_inode->i_sb != dst_inode->i_sb)
>> >> -            return -EXDEV;
>> >> +    if (src_inode->i_sb != dst_inode->i_sb) {
>> >> +            struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
>> >> +
>> >> +            if (ceph_fsid_compare(&src_fsc->client->fsid,
>> >> +                                  &dst_fsc->client->fsid)) {
>> >> +                    dout("Copying object across different clusters:");
>> >> +                    dout("  src fsid: %pU dst fsid: %pU\n",
>> >> +                         &src_fsc->client->fsid, &dst_fsc->client->fsid);
>> >> +                    return -EXDEV;
>> >> +            }
>> >> +    }
>> >
>> > Just to be clear: what happens here if I mount two entirely separate
>> > clusters, and their OSDs don't have any access to one another? Will this
>> > fail at some later point with an error that we can catch so that we can
>> > fall back?
>>
>> This is exactly what this check prevents: if we have two CephFS from two
>> unrelated clusters mounted and we try to copy a file across them, the
>> operation will fail with -EXDEV[1] because the FSIDs for these two
>> ceph_fs_client will be different.  OTOH, if these two filesystems are
>> within the same cluster (and thus with the same FSID), then the OSDs are
>> able to do 'copy-from' operations between them.
>>
>> I've tested all these scenarios and they seem to be handled correctly.
>> Now, I'm assuming that *all* OSDs within the same ceph cluster can
>> communicate between themselves; if this assumption is false, then this
>> patch is broken.  But again, I'm not aware of any mechanism that
>> prevents 2 OSDs from communicating between them.
>
> Your assumption is correct: all OSDs in a Ceph cluster can communicate
> with each other. I'm not aware of any plans to change this.
>
> I spent a bit of time trying to figure out how this could break
> security models and things and didn't come up with anything, so I
> think functionally it's fine even though I find it a bit scary.
>
> Also, yes, cluster FSIDs are UUIDs so they shouldn't collide.

Awesome, thanks for clarifying these points!

Cheers,
-- 
Luis


> -Greg
>
>>
>> [1] Actually, the files will still be copied because we'll fallback into
>> the default VFS generic_copy_file_range behaviour, which is to do
>> reads+writes operations.
>>
>> Cheers,
>> --
>> Luis
>>
>>
>> >
>> >
>> >>      if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>> >>              return -EROFS;
>> >>
>> >> @@ -1928,7 +1938,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >>       * efficient).
>> >>       */
>> >>
>> >> -    if (ceph_test_mount_opt(ceph_inode_to_client(src_inode), NOCOPYFROM))
>> >> +    if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
>> >>              return -EOPNOTSUPP;
>> >>
>> >>      if ((src_ci->i_layout.stripe_unit != dst_ci->i_layout.stripe_unit) ||
>> >> @@ -2044,7 +2054,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>> >>                              dst_ci->i_vino.ino, dst_objnum);
>> >>              /* Do an object remote copy */
>> >>              err = ceph_osdc_copy_from(
>> >> -                    &ceph_inode_to_client(src_inode)->client->osdc,
>> >> +                    &src_fsc->client->osdc,
>> >>                      src_ci->i_vino.snap, 0,
>> >>                      &src_oid, &src_oloc,
>> >>                      CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
>
