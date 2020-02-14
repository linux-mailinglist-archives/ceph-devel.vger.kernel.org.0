Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26C15D266
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Feb 2020 07:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgBNGte (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Feb 2020 01:49:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56900 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725845AbgBNGte (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Feb 2020 01:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581662972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xQ4sEKzdUU2nmBoghiELGZq7iIA9nHDNcYHzfI+Em9Y=;
        b=FspQmNgZAVcMJ7gGrmKGfI0I175ym+hgdJp85kIXaOA6lBqHMta30Ll7RmkURkkgF0xvuB
        gGOyBqzOORza0fVGgktDPKIfsCEqH3UtvQSpYyIkI2R+Lb49UDi3IzKibdNHSLmi/HvtPl
        0WziZ4IIoXQEtGcLRWZJiZJw+Wh69C0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-XYuFw84yNCK0kc69RnfdbA-1; Fri, 14 Feb 2020 01:49:29 -0500
X-MC-Unique: XYuFw84yNCK0kc69RnfdbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FE20107ACC9;
        Fri, 14 Feb 2020 06:49:28 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04F591001DD8;
        Fri, 14 Feb 2020 06:49:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix and update the mount options
Date:   Fri, 14 Feb 2020 01:49:13 -0500
Message-Id: <20200214064913.3965-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the quotadf option, acutally the default is enabled. At the
same time this will add all the other mount options with the detail
info.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 Documentation/filesystems/ceph.txt | 191 +++++++++++++++++++++++++----
 1 file changed, 169 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/ceph.txt b/Documentation/filesyste=
ms/ceph.txt
index 92ffc9b3b018..e446f5975e8d 100644
--- a/Documentation/filesystems/ceph.txt
+++ b/Documentation/filesystems/ceph.txt
@@ -102,6 +102,86 @@ Mount Options
 	specified, the client's IP address is determined by looking at the
 	address its connection to the monitor originates from.
=20
+  fsid=3DX
+        Specify the cluster's FSID/UUID.
+
+  name=3DX
+	RADOS user to authenticate as when using CephX. Default: guest
+
+  secret=3DX
+	Specify the secret key for use with CephX. This option is insecure
+	because it exposes the secret on the command line. To avoid this,
+	use the secretfile option.
+
+  key=3DX
+	Get secret key from the kernel keys api. More detail please see
+	Documentation/security/keys/core.rst.
+
+  osdkeepalive=3DX
+	The interval for sending the keepalive (tag + timestamp) to its OSD
+	to ensure any communications channel reset is detected. Default: 5
+	seconds.
+
+  osd_idle_ttl=3DX
+	The ttl for the osds in the lru list, will close and remove those
+	have not been used for more than a specified time. Default: 60
+	seconds.
+
+  mount_timeout=3DX
+	Specify the timeout value for mount (in seconds), in the case of
+	a non-responsive Ceph file system. Default: 60 seconds.
+
+  osd_request_timeout=3DX
+	Specify the timeout value for each osd request (in seconds), in
+	the case of non-responsive and will abort it. Default: 0 seconds,
+	means no timeout.
+
+  share
+	Share the client instance with other superblocks when mounting the
+	same cluster. This is the default.
+
+  noshare
+	Create a new client instance, instead of sharing an existing instance
+	of a client mounting the same cluster.
+
+  crc
+	Use CRC32C calculation for data writes. This is the default.
+
+  nocrc
+	Disable CRC32C calculation for data writes.  If set, the storage node
+	must rely on TCP's error correction to detect data corruption
+	in the data payload.
+
+  cephx_require_signatures
+	Enable require cephx message signing feat. This is the default.
+
+  nocephx_require_signatures
+	Disable require cephx message signing feat.
+
+  cephx_sign_messages
+	Enable message signing. This is the default.
+
+  nocephx_sign_messages
+	Disable message signing.
+
+  tcp_nodelay
+	Disable Nagle's algorithm on client sockets. This is the default.
+
+  notcp_nodelay
+        Enable Nagle's algorithm on client sockets.
+
+  abort_on_full
+	Fail write requests with -ENOSPC when the cluster is full or the data
+	pool reaches its quota. The default behaviour is to block until the
+	full condition is cleared.
+
+  snapdirname=3DX
+	Specify the name of the hidden snapdir. The default is ".snap".
+
+  mds_namespace=3DX
+	Specify the name of one filesystem to mount if you have more than
+	one filesystem.
+
   wsize=3DX
 	Specify the maximum write size in bytes.  Default: 64 MB.
=20
@@ -111,52 +191,119 @@ Mount Options
   rasize=3DX
 	Specify the maximum readahead size in bytes.  Default: 8 MB.
=20
-  mount_timeout=3DX
-	Specify the timeout value for mount (in seconds), in the case
-	of a non-responsive Ceph file system.  The default is 60
-	seconds.
+  caps_wanted_delay_min=3DX
+	Specify the minimum amount of time for telling the MDS we no
+	longer want caps, in case we reopen the file. Default: 5 seconds.
+
+  caps_wanted_delay_max=3DX
+	Specify the maximum amount of time for telling the MDS we no
+	longer want caps, in case we reopen the file. Default: 60 seconds.
=20
   caps_max=3DX
 	Specify the maximum number of caps to hold. Unused caps are released
 	when number of caps exceeds the limit. The default is 0 (no limit)
=20
+  readdir_max_entries=3DX
+	Specify the maximum directy entries to read per-request. Default:
+	1024.
+
+  readdir_max_bytes=3DX
+	Specify the maximum bytes could read per-request when reading directy
+	entries. Default: 512k.
+
+  congestion_kb=3DX
+	Specify the maximum writeback in flight, scale with available memory.
+	Default: calculated from available memory, but limit the default to
+	256M, at least 1M.
+
+  dirstat
+	Enable funky cat dirname for stats.
+
+  nodirstat
+	Disable funky cat dirname for stats. This is the default.
+
   rbytes
 	When stat() is called on a directory, set st_size to 'rbytes',
 	the summation of file sizes over all files nested beneath that
 	directory.  This is the default.
=20
   norbytes
-	When stat() is called on a directory, set st_size to the
-	number of entries in that directory.
-
-  nocrc
-	Disable CRC32C calculation for data writes.  If set, the storage node
-	must rely on TCP's error correction to detect data corruption
-	in the data payload.
+	When stat() is called on a directory, set st_size to the number
+	of entries in that directory.
=20
   dcache
-        Use the dcache contents to perform negative lookups and
-        readdir when the client has the entire directory contents in
-        its cache.  (This does not change correctness; the client uses
-        cached metadata only when a lease or capability ensures it is
-        valid.)
+        Use the dcache contents to perform negative lookups and readdir
+	when the client has the entire directory contents in its cache.
+	(This does not change correctness; the client uses cached metadata
+	 only when a lease or capability ensures it is valid.)  This is
+	the default.
=20
   nodcache
         Do not use the dcache as above.  This avoids a significant amoun=
t of
         complex code, sacrificing performance without affecting correctn=
ess,
         and is useful for tracking down bugs.
=20
+  asyncreaddir
+	Enable to use the dcache as above for readdir. This is the default.
+
   noasyncreaddir
-	Do not use the dcache as above for readdir.
+	Disable to use the dcache as above for readdir.
=20
-  noquotadf
+  ino32
+	Enable and force the ceph fs to report 32 bit ino values. This is
+	useful for 64 bit kernels with 32 bit userspace.
+
+  noino32
+	Disable forcing the ceph fs to report 32 bit ino values. This is
+	the default.
+
+  fsc=3DX
+	Enable and use fscache cookie as a local presisent cache with a unique
+	qualifier.
+
+  fsc
+	Enable and use fscache cookie as a local presisent cache without any
+	unique qualifier.
+
+  nofsc
+	Disable and do not use fscache cookie as a local presisent cache.
+
+  poolperm
+	Enable the pool rd/wr permission check for read/write. This is the
+	default.
+
+  nopoolperm
+	Disable the pool rd/wr permission check for read/write.
+
+  require_active_mds
+	Enable mount waits if no mds is up.
+
+  norequire_active_mds
+	Disablee mount waits if no mds is up. This is the default.
+
+  quotadf
         Report overall filesystem usage in statfs instead of using the r=
oot
-        directory quota.
+        directory quota. This is the default.
=20
-  nocopyfrom
-        Don't use the RADOS 'copy-from' operation to perform remote obje=
ct
+  noquotadf
+	Disable and do not report overall filesystem usage in statfs instead
+	of using the root directory quota.
+
+  copyfrom
+        Enable and use the RADOS 'copy-from' operation to perform remote=
 object
         copies.  Currently, it's only used in copy_file_range, which wil=
l revert
-        to the default VFS implementation if this option is used.
+        to the default VFS implementation if this option is used. This i=
s the
+	default.
+
+  nocopyfrom
+        Disable to use the RADOS 'copy-from' operation to perform remote=
 object
+	copies.
+
+  acl
+	Enable the acl. This is the default.
+
+  noacl
+	Disable the acl.
=20
   recover_session=3D<no|clean>
 	Set auto reconnect mode in the case where the client is blacklisted. Th=
e
--=20
2.21.0

